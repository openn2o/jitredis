--[[
数码分布式中间件 vip 客户端库
多核心处理，多个worker
--]]

local _M  = {}
local apollo = require ("suma_apollo_server")
local http   = require("http");
local cjson  = require("cjson");
local open   = io.open;
local native_client = require("suma_native_client")
local cache_ngx     = ngx.shared.ngx_share_dict;
if not ngx then
	ngx = {}
end
_M.caches = {}
_M.set_to_cache   = function (key, value)
    local succ = cache_ngx:set(key, value)
    return succ
end

_M.get_to_cache   = function (key)
    return cache_ngx:get(key)
end

_M.flush_dns_to_cache  = function (vips)
    if vips ~= nil then
        for k, v in ipairs(vips) do
            _M.set_to_cache (v.vip, cjson.encode(v));
        end
    else
        ngx.log(ngx.ERR, "not find data in vips");
        return;
    end
end

_M.flush_dns_to_host   = function (vips)
    local cmd  = {};
    local cstr = '127.0.0.1' .. " ";
    if vips ~= nil then
        for k, v in ipairs(vips) do
            cmd[k] = cstr .. v.vip .. "\n"
        end
    else
        ngx.log(ngx.ERR, "not find data in vips");
        return;
    end
    local file = open("/etc/hosts", "a+")
    if not file then
        ngx.log(ngx.ERR, "not find the hosts path");
        return ;
    end
    file:write(table.concat(cmd))
    file:close()
    native_client.native_merge_vips();
end

local json_decode = cjson.decode;
local cache_get   = _M.get_to_cache;

--snapshot
_M.id = ngx.worker.id();


_M.raw_get_live_subtask_infos = function ()
    -- local lock_m = cache_ngx:get("live_vip_infos" .. _M.id);
    -- if not lock_m then
    --     _M.vipserver_init ();
    --     local livekeys = apollo.suma_vip_list() or {}; -- 实时

    --     -- ngx.log(ngx.ERR, "livekeys=" .. cjson.encode(livekeys)) ;
    --     local tmp = {}
    --     if type(livekeys) == "string" then
    --         livekeys  = {livekeys}
    --     end

    --     for k, v in ipairs(livekeys) do
    --         local cdx = cache_get (v)
    --         if cdx ~= nil then
    --             tmp[k]= json_decode(cdx);
    --         end
    --     end
    --     -- ngx.log(ngx.ERR, "vipserver get=>" .. cjson.encode(tmp))
    --     _M.caches = tmp;
    --     cache_ngx:set("live_vip_infos" ..  _M.id, 1, 1);
    --     return tmp;
    -- end
    -- return _M.caches;
end
_M.raw_get_live_vip_infos = function ()
    local lock_m = cache_ngx:get("live_vip_infos" .. _M.id);
    if not lock_m then
        _M.vipserver_init ();
        local livekeys = apollo.suma_vip_list() or {}; -- 实时

        -- ngx.log(ngx.ERR, "livekeys=" .. cjson.encode(livekeys)) ;
        local tmp = {}
        if type(livekeys) == "string" then
            livekeys  = {livekeys}
        end

        for k, v in ipairs(livekeys) do
            local cdx = cache_get (v)
            if cdx ~= nil then
                tmp[k]= json_decode(cdx);
            end
        end
        -- ngx.log(ngx.ERR, "vipserver get=>" .. cjson.encode(tmp))
        _M.caches = tmp;
        cache_ngx:set("live_vip_infos" ..  _M.id, 1, 1);
        return tmp;
    end
    return _M.caches;
end

---初始化
_M.vipserver_init = function ()
    -- _M.raw_get_live_vip_infos();
    local data = apollo.suma_vip_server_list();
    ngx.log(ngx.ERR, "vip-server to cache=" .. cjson.encode(data));
    local ret  = {}
    if nil ~= data then
          if 0 ~= tonumber(data) then
              for  k, v in ipairs(data) do
                local t = json_decode(v);
                ret[k]  = t;
              end
              _M.flush_dns_to_cache(ret);
            --   _M.flush_dns_to_host (ret);
          end
    end
end

return _M;