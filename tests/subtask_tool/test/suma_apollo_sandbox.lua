--suma scripting sandbox
if not ngx then
	ngx = {}
end


local sandbox = {

}

local BASE_ENV = {}

([[

_VERSION assert error    ipairs   next pairs
pcall    select tonumber tostring type unpack xpcall

coroutine.create coroutine.resume coroutine.running coroutine.status
coroutine.wrap   coroutine.yield

math.abs   math.acos math.asin  math.atan math.atan2 math.ceil
math.cos   math.cosh math.deg   math.exp  math.fmod  math.floor
math.frexp math.huge math.ldexp math.log  math.log10 math.max
math.min   math.modf math.pi    math.pow  math.rad   math.random
math.sin   math.sinh math.sqrt  math.tan  math.tanh


string.byte string.char  string.find  string.format string.gmatch
string.gsub string.len   string.lower string.match  string.reverse
string.sub  string.upper

table.insert table.maxn table.remove table.sort
require ngx
]]):gsub('%S+', function(id)
  local module, method = id:match('([^%.]+)%.([^%.]+)')
  if module then
    BASE_ENV[module]         = BASE_ENV[module] or {}
    BASE_ENV[module][method] = _G[module][method]
  else
    BASE_ENV[id] = _G[id]
  end
end)

local function protect_module(module, module_name)
  return setmetatable({}, {
    __index = module,
    __newindex = function(_, attr_name, _)
      error('Can not modify ' .. module_name .. '.' .. attr_name .. '. Protected by the sandbox.')
    end
  })
end

('coroutine math os string table'):gsub('%S+', function(module_name)
  BASE_ENV[module_name] = protect_module(BASE_ENV[module_name], module_name)
end)

local string_rep = string.rep
local function merge(dest, source)
  for k,v in pairs(source) do
    dest[k] = dest[k] or v
  end
  return dest
end

local function sethook(f, key, quota)
  if type(debug) ~= 'table' or type(debug.sethook) ~= 'function' then return end
  debug.sethook(f, key, quota)
end

local function cleanup()
  sethook()
  string.rep = string_rep
end

-- Public interface: sandbox.protect
function sandbox.protect(f, options)
  if type(f) == 'string' then f = assert(loadstring(f)) end

  options = options or {}

  local quota = false
  if options.quota ~= false then
    quota = options.quota or 500000
  end

  local env   = merge(options.env or {}, BASE_ENV)
  env._G = env._G or env

  local _ngx = ngx;
  local eax  = function () end;
  -- _ngx.log   = eax;
  -- _ngx.say  = eax;
  -- _ngx.print= eax;
  _ngx.exit = eax;
  _ngx.redirect = eax;
  env.ngx   = _ngx;
  
  setfenv(f, env)

  return function(...)

    if quota then
      local timeout = function()
        cleanup()
        ngx.log(ngx.ERR , 'Quota exceeded: ' .. tostring(quota))
        return false;
      end
      sethook(timeout, "", quota)
    end

    string.rep = nil

    local ok, result = pcall(f, ...)

    cleanup()

    if not ok then
         ngx.log(ngx.ERR , "err" .. result)
         return -1;
    end
    return result
  end
end

function sandbox.run(f, options, ...)
  return sandbox.protect(f, options)(...)
end
setmetatable(sandbox, {__call = function(_,f,o) return sandbox.protect(f,o) end})

return sandbox
