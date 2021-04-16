---
-- native 本地非阻塞的系统功能调用模块
-- http   方式调用
---
if not ngx then
	ngx = {}
end
local http  	 = require("http");
local server     = require("suma_apollo_server");
local LOCAL_NATIVE_IP = "http://127.0.0.1:10082/"
local _M = {}


local cache_ngx = ngx.shared.ngx_share_dict;

_M.set_to_cache   = function (key, value)
    local succ, err, forcible = cache_ngx:set(key, value)
    return succ
end

_M.get_to_cache   = function (key)
    return cache_ngx:get(key)
end

function local_ip_file_read()
	local f = io.open("/home/admin/local_ip", "r")
	if f == nil then
		return nil;
	end
	local d = f:read("*all")
	f:close();
	return d;
end

_M.native_upload_local_mem = function ()
    local uric = LOCAL_NATIVE_IP .. "/2020/v1/suma_native/get_native_mem.mxml";

    local params = {
        ssl_verify = false,
        method     = "GET"
     }
     params.headers = {};
     local httpd   	  = http.new() ;
     local rres, rerr = httpd:request_uri(uric, params) ;
     if rerr ~= nil then
        ngx.log(ngx.ERR, rerr);
    end
    if rres ~= nil then
         local meme_size = string.gsub(rres.body, "\n", "") ;
         if nil ~=  meme_size then
            ngx.log(ngx.ERR, "meme size=" .. meme_size);
            local mem_avg = math.ceil(tonumber(meme_size) / 100);
            ngx.log(ngx.ERR, "meme avg=" .. mem_avg);
            _M.set_to_cache("apollo_local_avg", mem_avg);
            _M.set_to_cache("local_vip_limit", meme_size);
            server.upload_vip_mem_info();
         end
    end
end
---vip 缓存合并
_M.native_merge_vips = function ()
    local uric = LOCAL_NATIVE_IP .. "/2020/v1/suma_native/reload_vip_hosts.mxml";
    local params = {
        ssl_verify = false,
        method     = "GET"
     }
     params.headers = {};
     local httpd   	  = http.new() ;
     httpd:request_uri(uric, params) ;
end

_M.native_client_init = function ()
    _M.native_flush_ip() --上报ip
    _M.native_upload_local_mem () --上报默认的限流数
    local m = require("suma_code_manager");
    local codec  = [[
        local _M = {}
        _M.hello = function ()
            ngx.say("It works!");
        end
        return _M;
    ]]
    m.set_code("status", codec);
    m.init_code();
end

---把ip 缓存到共享dict
_M.native_flush_ip = function ()
    local flush_ip = LOCAL_NATIVE_IP .. "/2020/v1/suma_native/local_ip.mxml";
    local params = {
        ssl_verify = false,
        method     = "GET"
     }
     params.headers = {};
     local httpd   	  = http.new() ;
     local rres, rerr = httpd:request_uri(flush_ip, params) ;
     if rres ~= nil then
         local native_ip= string.gsub(rres.body, "\n", "") ;
         if nil ~=  native_ip then
            if "404 Not Found" ~= native_ip then
             local contentType = server.content_type();
             if contentType ~= nil then -- docker
                 local gen_ip = server.gen_ip();
                 _M.set_to_cache("apollo_local_ip2", native_ip);
                 _M.set_to_cache("apollo_local_ip",  native_ip);
                 server.build_vip_key(native_ip)
             else
                local gen_ip = server.gen_ip();
                 _M.set_to_cache("apollo_local_ip",  native_ip);
                 _M.set_to_cache("apollo_local_ip2", native_ip);
                 server.build_vip_key(native_ip)
             end
             local env_port = os.getenv("APOLLO_PORT");

             if env_port ~= nil then
                _M.set_to_cache("apollo_port", env_port);
             else
                _M.set_to_cache("apollo_port", 80);
             end

             server.suma_vip_register();

             return native_ip
            end
         end
     end
     ngx.log(ngx.ERR, "native client url get  error.");
     local native_ip = local_ip_file_read()
     native_ip = string.gsub(native_ip, "\n", "");
     if native_ip ~= nil then
        -- server.build_vip_key(lc_ip)
        if "404 Not Found" ~= native_ip then
            local contentType = server.content_type();
            if contentType ~= nil then -- docker
                local gen_ip = server.gen_ip();
                _M.set_to_cache("apollo_local_ip2", native_ip);
                _M.set_to_cache("apollo_local_ip",  gen_ip);
                server.build_vip_key(gen_ip)
            else
                local gen_ip = server.gen_ip();
                _M.set_to_cache("apollo_local_ip", native_ip);
                _M.set_to_cache("apollo_local_ip2", native_ip);
                server.build_vip_key(gen_ip)
            end
            server.suma_vip_register();
            return;
        end
     end
    --  ngx.log(ngx.ERR, "native client io error.");
end
return _M;