local apollo = require ("suma_apollo_server")
local redis  = require("suma_apollo_redis");
local cjson  = require "cjson"
local gsub 	 = string.gsub;
local _M = {}
if not ngx then
	ngx = {}
end
_M.build_deamond_key = function (k) 
    local channel_id = apollo.build_pubsub_channel();
    return channel_id .. k;
end
-- sumavlib.suma_diamond_publish owner_idbuiness_idchannel a vv
-----diamond publish key and value

---
-- 发布配置
---
_M.diamond_config_publish = function (key, value)
    local diamond_key = _M.build_deamond_key(key);
    local ret = apollo.suma_diamond_publish(diamond_key, value);
    return ret;
end

---
-- 获取本地配置
---

_M.diamond_config_cache_get = function (key)
    local cache_ngx = ngx.shared.ngx_share_dict;
    return cache_ngx:get(key)
end

---获取列表
_M.diamond_config_list = apollo.suma_diamond_list;

---
-- 初始化阶段拉取配置
---
_M.diamond_config_init = function ()
    local list = _M.diamond_config_list()

    if not list then
        return;
    end

    if tonumber (list) == 0 then
        return ;
    end

    --- 非阻塞 get data
    local redis_c     = redis:new();
    local ok, err     = redis_c:connect(apollo.redis_host, 
                                        apollo.redis_port)
    redis_c:set_timeout(5000);
    local channel = apollo.build_pubsub_channel();
    local curl    = apollo.get_to_cache("web_hook")

    -- ngx.log(ngx.ERR,cjson.encode(list))
    for k, v in ipairs(list) do
        local resp, err = redis_c:get(v);
        if resp then
            local local_key = gsub (v, channel , "");
            apollo.set_to_cache(local_key, resp);

            if apollo.get_to_cache(local_key) == nil then
                ngx.log(ngx.ERR, local_key .. " error")
            end
            if  curl ~= nil then
                ---post k v
                local params = {  
                    ssl_verify = false,
                    method     = "POST"
                };
                params.headers = {};
                params.headers ["Content-Type"]  = "application/json";
                params.headers ["User-Agent"]    = "web hook"

                local pack = {};
                pack.key   = local_key;
                pack.value = resp
                params.body= cjson.encode(pack) ;
                local httpd   = http.new();
                local rres, rerr = httpd:request_uri(curl, params) ;
                if rres == nil then
                    redis_c:close()
                    return;
                end
            end
        end
    end
    redis_c:close()
end

return _M;