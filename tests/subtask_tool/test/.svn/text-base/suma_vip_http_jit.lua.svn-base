local _M = {}
if not ngx then
	ngx = {}
end
local cjson = require("cjson");
local cache_ngx            = ngx.shared.ngx_share_dict;
local __inline__get_header = ngx.req.get_headers;

local math_rnd  = math.random;
-- math.randomseed(ngx.now() * 1000);

_M.get_headers = function ()
    local rax = ngx.ctx.header;
    if rax == nil then
        ngx.ctx.header = __inline__get_header ();
        rax = ngx.ctx.header ;
    end
    return rax;
end

local __avg_pool__ = {};
_M.vip_cahce = {}
_M.max_avg_load_count = 0;
_M.vip_live_cache  = nil;
_M.id   =  ngx.worker.id();
_M.avg = function  ()
    ---锁
    local lock_m = cache_ngx:get("mutex_task" .. _M.id);
    if not lock_m then
        cache_ngx:set("mutex_task" ..  _M.id, 1, 1);
        __avg_pool__ = {}
        local cache = cache_ngx:get("master_avg_list");
        local list  = cjson.decode(cache);
        if list then
            local index = 1;
            local pos   = 1;
            local live_cahe  = cache_ngx:get("vip_list_cache_key");
            -- ngx.log(ngx.ERR, "avg=" .. tostring(live_cahe));
            if live_cahe == nil  then
                live_cahe = '[]'
            end
            local live =  cjson.decode(live_cahe);
            _M.vip_live_cache = live;

            for k,v in ipairs(live) do
                if v ~= nil then
                    __avg_pool__[index]     = {} ;
                    __avg_pool__[index].s   = pos;
                    if list[v] == nil then
                        list[v] = 0;
                    end
                    __avg_pool__[index].e   = pos + tonumber(list[v]);
                    _M.max_avg_load_count   = __avg_pool__[index].e ;
                    pos = __avg_pool__[index].e + 1;
                    index = index + 1;
                end
            end
        end
    end
    if _M.vip_live_cache then
        return _M.vip_live_cache;
    end
end

---测试 多核心处理
-- cache_ngx:set("key1" ,0);
-- cache_ngx:set("key2" ,0);
-- cache_ngx:set("key3" ,0);
-- cache_ngx:set("key4" ,0);
-- cache_ngx:set("key5" ,0);
_M.load_calc = function ()
    local avgs = __avg_pool__;
    local rank = math_rnd(_M.max_avg_load_count);
    for k, v in ipairs(avgs) do
      if rank >= v.s and  rank <= v.e then
        return k;
      end
    end
    return 1;
end

--jit the vip for cache
_M.vip_info_jit_get = function (host)
    if host == nil then
        ngx.log(ngx.ERR, "[error] not find host")
        return nil;
    end
    local eax  =  _M.vip_cahce [host];
    if nil ~= eax then
        ngx.log(ngx.ERR, "eax = " .. cjson.encode(eax));
        return eax;
    end

    ngx.log(ngx.ERR, "host=" .. tostring(host));
    -- local vip_data = cache_ngx:get(host);
    local vip_data =  nil;
    if vip_data ~= nil then
        eax = cjson.decode(vip_data);
        if eax.scheme == nil then
            eax.scheme = 'http';
        end
        if eax.raw ~= nil then
            eax.ip = eax.raw;
        end
        if eax.ip == nil then
            eax.ip = "127.0.0.1";
        end
        eax.ip = string.gsub(eax.ip, "\n", "");
        if  eax.port == nil then
            eax.port = 80;
        end
        if eax.ip == _M.local_ip_jit_get() then
            eax.upstream  =  eax.scheme .. "://127.0.0.1:".. eax.port
        else
            eax.upstream  =  eax.scheme .. "://".. eax.ip ..":".. eax.port
        end
        _M.vip_cahce [host] = eax;
    else
        if not ngx.ctx.buiness_id then
            ngx.log(ngx.ERR, "not find bid");
            return;
        end

        if not ngx.ctx.token then
            ngx.log(ngx.ERR, "not find token");
            return;
        end

        local lock_key = host .. ngx.worker.id() .. ".vip_install_lock";
        local try_lock = cache_ngx:get(lock_key);
        if  try_lock ~=1 then
            local server= require("suma_apollo_server")
            local data = server.suma_vip_server_list();
            local ret  = {}
            for  k, v in ipairs(data) do
                local d =  cjson.decode(v);
                if d ~= nil then
                    _M.vip_cahce [d.vip] = d;
                end
            end
            cache_ngx:set(lock_key, 60);
            eax  =  _M.vip_cahce [host];
        end
    end
    return eax;
end

_M.vip_upstream_jit_get=function (host)
    local eax  =  _M.vip_cahce [host];
    if nil ~= eax then
        if eax.upstream ~= nil then
            return eax.upstream;
        end
    end
    return nil;
end

--jit the local ip for cahce
_M.vip_local_ip = nil;
_M.local_ip_jit_get = function ()
    local eax = _M.vip_local_ip
    if  nil ~= eax then
        return eax;
    end
    local local_ip = cache_ngx:get("apollo_local_ip");
    if local_ip ~= nil then
        eax =  string.gsub(local_ip, "\n", "");
        _M.vip_local_ip = eax;
    end
    return eax;
end

return _M;