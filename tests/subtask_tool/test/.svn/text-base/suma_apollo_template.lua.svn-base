--[[
    基于jit的模板引擎
	agent.zy@aliyun.com	
--]]

local setmetatable = setmetatable
local loadstring   = loadstring
local loadchunk
local tostring = tostring
local setfenv = setfenv
local require = require
local capture
local concat = table.concat
local dump = string.dump
local find = string.find
local gsub = string.gsub
local byte = string.byte


local assert = assert
local prefix
local write = io.write
local pcall = pcall
local phase
local open = io.open
local load = load
local type = type

local null
local sub = string.sub
local ngx = ngx
local jit = jit
local var
local match_str = [[(%{%# [ A-Z a-z 0-9 %s ].+ %#%})]]
local _VERSION = _VERSION
local _ENV = _ENV
local _G = _G

local HTML_ENTITIES = {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;"
}

local CODE_ENTITIES = {
    ["{"] = "&#123;",
    ["}"] = "&#125;",
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;"
}

local ESC    = byte("\27")
local NUL    = byte("\0")
local HT     = byte("\t")
local VT     = byte("\v")
local LF     = byte("\n")
local SOL    = byte("/")
local BSOL   = byte("\\")
local SP     = byte(" ")
local AST    = byte("*")
local NUM    = byte("#")
local LPAR   = byte("(")
local LSQB   = byte("[")
local LCUB   = byte("{")
local MINUS  = byte("-")
local PERCNT = byte("%")

local EMPTY  = ""
local VAR_PHASES

local ok, newtab = pcall(require, "table.new")
if not ok then newtab = function() return {} end end

local caching  = true
local template = newtab(0, 100)
template._VERSION = "0.1"
template.cache    = {}


local function enabled(val)
    if val == nil then return true end
    return val == true or (val == "1" or val == "true" or val == "on")
end

local function trim(s)
	if nil == s then
		return "";
	end
    return s;
	--return gsub(gsub(s, "^%s+", EMPTY), "%s+$", EMPTY)
end

local function rpos(view, s)
    while s > 0 do
        local c = byte(view, s, s)
        if c == SP or c == HT or c == VT or c == NUL then
            s = s - 1
        else
            break
        end
    end
    return s
end

local function escaped(view, s)
    if s > 1 and byte(view, s - 1, s - 1) == BSOL then
        if s > 2 and byte(view, s - 2, s - 2) == BSOL then
            return false, 1
        else
            return true, 1
        end
    end
    return false, 0
end

local function readfile(path)
    local file = open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function loadlua(path)
    return readfile(path) or path
end

local function loadngx(path)
    local vars = VAR_PHASES[phase()]
    local file, location = path, vars and var.template_location
    if byte(file, 1)  == SOL then file = sub(file, 2) end
    if location and location ~= EMPTY then
        if byte(location, -1) == SOL then location = sub(location, 1, -2) end
        local res = capture(concat{ location, "/", file})
        if res.status == 200 then return res.body end
    end
    local root = vars and (var.template_root or var.document_root) or prefix
    if byte(root, -1) == SOL then root = sub(root, 1, -2) end
    return readfile(concat{ root, "/", file }) or path
end

do
    if ngx then
        VAR_PHASES = {
            set           = true,
            rewrite       = true,
            access        = true,
            content       = true,
            header_filter = true,
            body_filter   = true,
            log           = true
        }
        template.print = ngx.print or write
        template.load  = readfile
    else
        template.print = write
        template.load  = loadlua
    end
    if _VERSION == "Lua 5.1" then
        local context = { __index = function(t, k)
            return t.context[k] or t.template[k] or _G[k]
        end }
        if jit then
            loadchunk = function(view)
                return assert(load(view, nil, nil, setmetatable({ template = template }, context)))
            end
        else
            loadchunk = function(view)
                local func = assert(loadstring(view))
                setfenv(func, setmetatable({ template = template }, context))
                return func
            end
        end
    else
        local context = { __index = function(t, k)
            return t.context[k] or t.template[k] or _ENV[k]
        end }
        loadchunk = function(view)
            return assert(load(view, nil, nil, setmetatable({ template = template }, context)))
        end
    end
end

function template.caching(enable)
    if enable ~= nil then caching = enable == true end
    return caching
end

function template.output(s)
    if s == nil or s == null then return EMPTY end
    if type(s) == "function" then return template.output(s()) end
    return tostring(s)
end

function template.escape(s, c)
    if type(s) == "string" then
        if c then return gsub(s, "[}{\">/<'&]", CODE_ENTITIES) end
        return gsub(s, "[\">/<'&]", HTML_ENTITIES)
    end
    return template.output(s)
end

function template.new(view, layout)
    assert(view, "view was not provided for template.new(view, layout).")
    local render, compile = template.render, template.compile
    if layout then
        if type(layout) == "table" then
            return setmetatable({ render = function(self, context)
                context = context or self
                context.blocks = context.blocks or {}
                context.view = compile(view)(context)
                layout.blocks = context.blocks or {}
                layout.view = context.view or EMPTY
                return layout:render()
            end }, { __tostring = function(self)
                local context = self
                context.blocks = context.blocks or {}
                context.view = compile(view)(context)
                layout.blocks = context.blocks or {}
                layout.view = context.view
                return tostring(layout)
            end })
        else
            return setmetatable({ render = function(self, context)
                context = context or self
                context.blocks = context.blocks or {}
                context.view = compile(view)(context)
                return render(layout, context)
            end }, { __tostring = function(self)
                local context = self
                context.blocks = context.blocks or {}
                context.view = compile(view)(context)
                return compile(layout)(context)
            end })
        end
    end
    return setmetatable({ render = function(self, context)
        return render(view, context or self)
    end }, { __tostring = function(self)
        return compile(view)(self)
    end })
end

function template.precompile(view, path, strip)
    local chunk = dump(template.compile(view), true)
    if path then
        local file,err = open(path, "wb")
		if not file then
			ngx.log(ngx.ERR, err) ;
			return nil;
		end
		file:write(chunk)
		file:close()
    end
    return chunk
end

function template.compile(view, key, plain)
    if key == "no-cache" then
        return loadchunk(template.parse(view, plain)), false
    end
    key = key or view
    local cache = template.cache
    if cache[key] then return cache[key], true end
    local func = loadchunk(template.parse(view, plain))
    if caching then cache[key] = func end
    return func, false
end

function template.parse(view, plain)
    if not plain then
        view = template.load(view)
		if nil == view then
			return '';
		end
        if byte(view, 1, 1) == ESC then return view end
    end
    local j = 2
    local c = {[[
context= ... or {}
local function include(v, c)
	if string.byte(v,pattern) == 34 then
		v = string.sub(v, 2, #v - 1);
	end
	if template[v] == nil then 
		local path      = "/home/admin/tml/" .. v .. ".json";
		local compiled  = template.precompile(path ,"/home/admin/wasm/" .. v ..".wasm");
		if compiled then
			template[v] = template.compile("/home/admin/wasm/" .. v ..".wasm");
		end
		return template[v](c or context);
	end
	
	return template.compile(v)(c or context) 
end

local ___,blocks,layout={},blocks or {}
local function echo(...) 
    local args = {...}
    for i=1,select("#", ...) do 
        args[i] = tostring(args[i])
    end
    ___[#___+1] = table.concat(args) 
end
]] }

	local code_debug = {};
	local function split( str,reps )
		local resultStrList = {}
		local _push = table.insert;
		gsub(str,'[^'..reps..']+',function ( w )
			_push(resultStrList,w)
		end)
		return resultStrList
	end
	if template.cache["opt"] then
		local opt_O0 = function (v)
			local i = 1;
			local n = table.getn(v);
			local vec = {};
			local ret = {};
			while( i <= n ) do
				-- 替换注释	
                v[i] = gsub(v[i], match_str, "");
				if #v[i] <= 2 then
					local codec = byte(v[i]);
					if 13 == codec or  9 == codec then
						--print(i, string.byte(v[i]), #v[i]);
						v[i] = "";
					end
				end
				-- 替换换行
				i = i+1;
            end
            local cc = concat(v);
            cc = gsub (cc, "template.escape", "");
			return cc;
		end
		--view = string.gsub(view, match_str, "");
		view = opt_O0(split(view, "\n"));
	end
    local i, s = 1, find(view, "{", 1, true)
    while s do
        local t, p = byte(view, s + 1, s + 1), s + 2
        if t == LCUB then
            local e = find(view, "}}", p, true)
            if e then
                local z, w = escaped(view, s)
                if i < s - w then
					c[j] = "___[#___+1]=[=[" .. sub(view, i, s - 1 - w) .. "]=] "
					j = j+1;
                end
                if z then
                    i = s
                else
					c[j] = "___[#___+1]=(" .. trim(sub(view, p, e - 1)) .. ")"
					j = j+1;
					s, i = e + 1, e + 2
                end
            end
        elseif t == AST then
            local e = find(view, "*}", p, true)
            if e then
                local z, w = escaped(view, s)
                if i < s - w then
                    c[j] = "___[#___+1]=[=[\n"
                    c[j+1] = sub(view, i, s - 1 - w)
                    c[j+2] = "]=]\n"
                    j=j+3
                end
                if z then
                    i = s
                else
                    c[j] = "___[#___+1]=template.output("
                    c[j+1] = trim(sub(view, p, e - 1))
                    c[j+2] = ")\n"
                    j=j+3
                    s, i = e + 1, e + 2
                end
            end
        elseif t == PERCNT then
            local e = find(view, "%}", p, true)
            if e then
                local z, w = escaped(view, s)
                if z then
                    if i < s - w then
						c[j] = "___[#___+1]=[=[" .. sub(view, i, s - 1 - w) .. "]=] "
                        j=j+1
                    end
                    i = s
                else
					local n = e + 2
                    if byte(view, n, n) == LF then
                        n = n + 1
                    end
                    local r = rpos(view, s - 1)
                    if i <= r then
						c[j] = "___[#___+1]=[=[ " .. sub(view, i, r) .. "]=]"
						j = j + 1;
                    end
                    c[j] = trim(sub(view, p, e - 1))
					j=j+1
                    s, i = n - 1, n
                end
            end
        elseif t == LPAR then
            local e = find(view, ")}", p, true)
            if e then
                local z, w = escaped(view, s)
                if i < s - w then
                    c[j] = "___[#___+1]=[=[\n"
                    c[j+1] = sub(view, i, s - 1 - w)
                    c[j+2] = "]=]\n"
                    j=j+3
                end
                if z then
                    i = s
                else
                    local f = sub(view, p, e - 1)
                    local x = find(f, ",", 2, true)
                    if x then
                        c[j] = "___[#___+1]=include([=["
                        c[j+1] = trim(sub(f, 1, x - 1))
                        c[j+2] = "]=],"
                        c[j+3] = trim(sub(f, x + 1))
                        c[j+4] = ")\n"
                        j=j+5
                    else
                        c[j] = "___[#___+1]=include([=["
                        c[j+1] = trim(f)
                        c[j+2] = "]=])\n"
                        j=j+3
                    end
                    s, i = e + 1, e + 2
                end
            end
        elseif t == LSQB then
            local e = find(view, "]}", p, true)
            if e then
                local z, w = escaped(view, s)
                if i < s - w then
                    c[j] = "___[#___+1]=[=[\n"
                    c[j+1] = sub(view, i, s - 1 - w)
                    c[j+2] = "]=]\n"
                    j=j+3
                end
                if z then
                    i = s
                else
                    c[j] = "___[#___+1]=include("
                    c[j+1] = trim(sub(view, p, e - 1))
                    c[j+2] = ")\n"
                    j=j+3
                    s, i = e + 1, e + 2
                end
            end
        elseif t == MINUS then
            local e = find(view, "-}", p, true)
            if e then
                local x, y = find(view, sub(view, s, e + 1), e + 2, true)
                if x then
                    local z, w = escaped(view, s)
                    if z then
                        if i < s - w then
                            c[j] = "___[#___+1]=[=[\n"
                            c[j+1] = sub(view, i, s - 1 - w)
                            c[j+2] = "]=]\n"
                            j=j+3
                        end
                        i = s
                    else
                        y = y + 1
                        x = x - 1
                        if byte(view, y, y) == LF then
                            y = y + 1
                        end
                        local b = trim(sub(view, p, e - 1))
                        if b == "verbatim" or b == "raw" then
                            if i < s - w then
                                c[j] = "___[#___+1]=[=[\n"
                                c[j+1] = sub(view, i, s - 1 - w)
                                c[j+2] = "]=]\n"
                                j=j+3
                            end
                            c[j] = "___[#___+1]=[=["
                            c[j+1] = sub(view, e + 2, x)
                            c[j+2] = "]=]\n"
                            j=j+3
                        else
                            if byte(view, x, x) == LF then
                                x = x - 1
                            end
                            local r = rpos(view, s - 1)
                            if i <= r then
                                c[j] = "___[#___+1]=[=[\n"
                                c[j+1] = sub(view, i, r)
                                c[j+2] = "]=]\n"
                                j=j+3
                            end
                            c[j] = 'blocks["'
                            c[j+1] = b
                            c[j+2] = '"]=include[=['
                            c[j+3] = sub(view, e + 2, x)
                            c[j+4] = "]=]\n"
                            j=j+5
                        end
                        s, i = y - 1, y
                    end
                end
            end
        elseif t == NUM then
            local e = find(view, "#}", p, true)
            if e then
                local z, w = escaped(view, s)
                if i < s - w then
                    --[[
					c[j] = "___[#___+1]=[=[\n"
                    c[j+1] = sub(view, i, s - 1 - w)
                    c[j+2] = "]=]\n"
                    j=j+3
					--]]
					c[j] = "___[#___+1]=[=[\n" .. sub(view, i, s - 1 - w) ..  "]=]\n"
					j=j+1
                end
                if z then
                    i = s
                else
                    e = e + 2
                    if byte(view, e, e) == LF then
                        e = e + 1
                    end
                    s, i = e - 1, e
                end
            end
        end
        s = find(view, "{", s + 1, true)
    end
    s = sub(view, i)
--[[
	if s and s ~= EMPTY then
        c[j] = "___[#___+1]=[=[\n"
        c[j+1] = s
        c[j+2] = "]=]\n"
        j=j+3
    end
--]]
	if s and s ~= EMPTY then
        c[j] = "___[#___+1]=[=[\n" .. s .. "]=]\n"
        j=j+1
    end
    c[j] = [[
	local __data = table.concat(___);
	return layout and include(layout,setmetatable({view=__data,blocks=blocks},{__index=context})) or __data
	]]
	----O1 优化级别 优化指令  1 剔除占位指令 2 合并多条到1条指令
    local opt_O1 = function (v) 
        local tbl_insert = table.insert;
		local i = 1;
		local n = table.getn(v);
		local vec = {};
        local ret = {};
        local merges = {};
		while( i <= n ) do
            local val      = trim(v[i]);
            local nextone  = trim(v[i+1]);
            local lookup   = trim(v[i+2]);
            if not lookup then lookup = "" end
			if ("___[#___+1]=[=[\n" == val) and ("]=]\n" == lookup) then
                if #nextone <= 2 and (byte(nextone) == 13 or byte(nextone) == 9) then
					vec[i]   = 0x81;
					vec[i+1] = 0x81;
                    vec[i+2] = 0x81;
                end
                i = i+2;
            elseif ("___[#___+1]=template.escape(\n" == val ) and (")\n" == lookup) then
                local m = val .. nextone .. lookup .. "\n"
                vec[i]   = m;
                vec[i+1] = 0x81;
                vec[i+2] = 0x81;
                i = i+2;
			end
			i = i+1;
		end
		i = 1;
		while( i <= n ) do
			if vec[i] ~= 0x81 then
				tbl_insert (ret, v[i]);
			end
			i = i+1;
		end
		return concat(ret);
	end
	local code_gen = nil;
	code_gen = opt_O1(c);
	--if template.cache["opt"] then
       -- code_gen = opt_O1(c);
    --else
      -- code_gen = concat(c);
	--end;
	return code_gen
end

function template.render(view, context, key, plain)
    assert(view, "view was not provided for template.render(view, context, key, plain).")
    return template.print(template.compile(view, key, plain)(context))
end

local function basename (path)
    if not path then
        return nil;
    end
	local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    return string.sub(filename, 1, extpos - 1)
end

local function split( str,reps )
		local resultStrList = {}
		local _push = table.insert;
		gsub(str,'[^'..reps..']+',function ( w )
			_push(resultStrList,w)
		end)
		return resultStrList
end

local function ngx_wasm_init()
	local cmd = [[find /home/admin/wasm/ -name "*.wasm"]]
	local t = io.popen(cmd)
	local result = t:read("*all")
	template.caching(true)
	template.cache['opt'] = 1;
	if result ~= nil then
        local files   = split(result , "\n");
        local work_id = ngx.worker.id(); 
		for k, v in ipairs(files) do
            local _basename = basename(v);
            if _basename ~= nil then
                template[_basename] = template.compile(v,_basename);
                if work_id == 0 then
                    ngx.log(ngx.ERR, "[tml]" .. _basename .. " add on");
                end
            end
		end
	end
end

local function ngx_tml_compile()
	local cmd = [[find /home/admin/tml/ -name "*"]]
	local t   = io.popen(cmd)
	local result = t:read("*all")
	if result ~= nil then
		local files = split(result , "\n");
		for k, v in ipairs(files) do
			local basename  = basename(v);
			local compiled  = template.precompile(v,"/home/admin/wasm/" .. basename ..".wasm");
		end
	end
end

template.init = function () 
	if ngx then
		ngx_tml_compile ();
		ngx_wasm_init   ();
	end
end

return template
