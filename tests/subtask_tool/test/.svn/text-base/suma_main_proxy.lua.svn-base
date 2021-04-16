-- return  ngx.exit(200)
if not ngx then
	ngx = {}
end
local cjson     = require "cjson"
local module    = require ("suma_upstream_client");
local http_jit  = require("suma_vip_http_jit");
local server    = require("suma_apollo_server");
local uri = ngx.var.request_uri;
if uri == "/favicon.ico" then
    ngx.exit(404);
    return;
end
local m   = module.split(uri, "/");
local len = #m;

if len < 1 then
    ngx.log(ngx.ERR, "len is null");
    ngx.exit(502);
    return
end


local inter_method = m[len];
local inter_module = m[len -1];

if nil == inter_method then
    ngx.log(ngx.ERR, "inter_method is null");
    ngx.exit(502);
    return
end
if nil == inter_module then
    ngx.log(ngx.ERR, "inter_module is null");
    ngx.exit(502);
    return
end

inter_method = module.match_mxml(inter_method)

-- local status, lib = pcall(require , inter_module)
local status, lib =  server.hot_code_reload(inter_module)
if status and lib then
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
    ngx.log(ngx.ERR, "method not find");
else
    ngx.exit(404); --没有找到模块
end