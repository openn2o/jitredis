-- 全部测试
-- 内部测试框架
----------------------------------------------------------------
local cjson = require("cjson");
local redis = require("suma_apollo_redis");
local server= require "suma_apollo_server"
local ffi  = require("ffi")
local def  = ffi.cdef;
local iload= ffi.load;
local cache_ngx = ngx.shared.ngx_share_dict;
if not ngx then
	ngx = {}
end

local _M = {}
_M.tasks = {}
if not ngx then
	ngx = {}
end
_M.set_to_cache   = function (key, value)
    local succ, err, forcible = cache_ngx:set(key, value)
    return succ
end

_M.get_to_cache   = function (key)
    return cache_ngx:get(key)
end

def[[
	void  free(void *ptr);
	struct timeval {
		long int tv_sec;
		long int tv_usec;
	};
	int gettimeofday(struct timeval *tv, void *tz);
]]

local tm = ffi.new("struct timeval");
function clock()
	ffi.C.gettimeofday(tm,nil);
	local sec  = tonumber(tm.tv_sec) * 1000000 ;
	local usec = tonumber(tm.tv_usec);
	return (sec + usec)  / 1000;
end



_M.add_task = function (task)
    if not task.desc then
        task.desc = ""
    end
    task.ip = _M.get_local_ip ();
    task.status = false;
    _M.tasks [#_M.tasks + 1] = task;
end

_M.get_local_ip = function ()
    local nc = require("suma_native_client");
    local ip = nc.get_to_cache("apollo_local_ip")
    return ip;
end

_M.run_task = function ()
    local flush = _M.task_flush;
    for k, v in ipairs(_M.tasks) do
        if v ~= nil then
            if v.func ~= nil then
                v.num     = k;
                v.cost    = clock();
                v.status  = v.func(v);
                flush(v);
            end
        end
    end
end

_M.task_flush = function (v)
    local server = require("suma_apollo_server");
    local red     = redis:new();
    local ok, err = red:connect(server.redis_host, 
                                server.redis_port)
    if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return red:close()
    end
    local msg = {}

    if v.num then
        msg.num = v.num;
    end
    msg.cost      = (clock() - v.cost);
    msg.name      = v.name;
    msg.status    = v.status;
    msg.desc      = v.desc;
    msg.ip        = v.ip;
    msg.vip       = server.get_to_cache("apollo_local_vip");
    local str     = cjson.encode(msg);
    local ckey    = tostring(ngx.encode_base64(msg.vip .. v.num)):reverse();
    local task_key= server.build_ci_task_key() ..  ckey  .. ".ci";
    red:set(task_key, str);
    red:expire(task_key, 10);
    redis:close();
end

---
-- 判断ip是否存在的测试
---
_M.add_task ({
    name = "suma native client 检测",
    desc = "suma native client 获取到本地的ip的检测",
    func = function (v)
        local nc = require("suma_native_client");
        local ip = nc.get_to_cache("apollo_local_ip")

        if nil ~= ip then
            return true;
        end
        return false;
    end
});

_M.add_task ({
    name = "suma diamond client 一致性检测",
    desc = "suma diamond 中间件的client和server对分发的数据同步和一致性的检测",
    func = function (v)
        local diamond_list = server.suma_diamond_list();
        if not diamond_list  then
            return false;
        end

        local status_num = 0;
        local m_sub = string.gsub;
        local m_search_key = server.build_pubsub_channel();
        for k, d in ipairs(diamond_list) do
            local key  = m_sub(d, m_search_key, "");
            local data = _M.get_to_cache (key);
            if nil == data then
                return false
            end
            status_num = status_num + 1;
        end

        if status_num == #diamond_list then
            return true;
        end
        return false;
    end
});



_M.add_task ({
    name = "suma vip client 同步检测",
    desc = "suma vip client 缓存vip 同步和一致性检测",
    func = function (v)
        local d = require("suma_vip_client");
        local m = d.raw_get_live_vip_infos();

        ngx.log(ngx.ERR ,cjson.encode(m))
        if m ~= nil then
            if #m > 0 then
                return true;
            end
        end
        return false;
    end
});

_M.add_task ({
    name = "suma upstream internal 路由检测",
    desc = "suma upstream internal 模块路由检测",
    func = function (v)
        local status, err = server.call_local_interface ("suma_echo" ,
         "echo",  function (body)
            local resp =  body;
            if resp == "echo" then
                return true, nil;
            end
            return false, nil;
        end)
        return status;
    end
});

-- _M.add_task ({
--     name = "suma upstream vip路由检测",
--     desc = "suma upstream vip inject 路由检测", 
--     func = function (v)
        
--         local inject_vip = [[
--             {"vip":"ci.ddd.vip","ip":"47.100.35.81","port":80}
--         ]]
        
--         local upstream = require("suma_vip_client")
--         local tmp = {}
--         tmp[1] = cjson.decode(inject_vip)
--         upstream.flush_dns_to_cache(tmp);
--         upstream.flush_dns_to_host (tmp);
        
--         local http     = require "resty.http" 
--         local test_uri = "http://127.0.0.1/t301";
--         local params = {  
--             ssl_verify = false,
--             method     = "GET",
--             host       = "CI.DDD.vip"
--         }
--         local httpd   	 = http.new() ;
--         local rres, rerr = httpd:request_uri(test_uri, params) ;
--         if rerr then
--             ngx.log(ngx.ERR, "dd=" .. rerr)
--             return false;
--         end
       
--         if rres ~= nil then
--             if  rres.body then
--                 return true;
--             end
--         end

--         return false;
--     end
-- });

-- _M.add_task ({
--     name = "suma apollo 基础设施签名验证",
--     desc = "suma apollo 基础设施签名检测", 
--     func = function (v)
--         local d  = [[2ca4697bf1e5b832f66e3658012c11c3a149075e877c325ee8d40d5332f1d9710aef4ab4f8a2eefc627be2bc04ef59269a4bd343ddcf9cd25b08acaf0159a611]]
--         local http     = require "resty.http" 
--         local params = {  
--            ssl_verify = false,
--            method     = "POST"
--         }
--         params.headers = {};
--         params.headers ["Content-Type"]  = "application/json";
--         params.headers ["User-Agent"]    = "DRMAgent";
--         local pack = {};
        
--         pack.source= d;
--         params.body= cjson.encode(pack);
--         local auth_url   = "http://127.0.0.1:9527/sign";
--         local httpd   	 = http.new() ;
--         local rres, rerr = httpd:request_uri(auth_url, params) ;
--         if rres ~= nil then
--             if 128 ==  #rres.body then
--                 return true;
--             end
--         end
--         return false;
--     end
-- });

return _M;
