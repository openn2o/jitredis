local _push     = table.insert;
local gsub      = string.gsub;
local find_s    = string.find;
local EXTENSION = ".mxml";
if not ngx then
	ngx = {}
end
local match_mxml = function (str)
    if str == nil then
        str = ""
    end
    local s, e = find_s(str, EXTENSION);
    if s ~= nil then
        return string.sub (str, 1, s - 1);
    end
    return str;
end

local split = function (str,reps)
    local loc = {}
    gsub(str,'[^'..reps..']+',function (w)
        _push(loc,w)
    end)
    return loc
end

local uri = ngx.var.request_uri;
local m   = split(uri, "/");
local len = #m;

if len < 0 then
    ngx.exit(502);
    return
end

local inter_method = m[len];
local inter_module = m[len -1];
if nil == inter_method then
    ngx.exit(502);
    return
end
if nil == inter_module then
    ngx.exit(502);
    return
end

inter_method = match_mxml(inter_method)
local status, lib = pcall(require , inter_module)
if status then
    local method = lib[inter_method]
    if  nil ~= method then
        local status, err  = pcall(method);
        if not status then
            ngx.log(ngx.ERR, err);
            return ngx.exit(403);
        end
        ngx.exit(200);
        return;
    end
    ngx.exit(502); 
else
    ngx.exit(404); --没有找到模块
end