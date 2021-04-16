--
-- Ocsp 处理
--

local _M = {}
local cjson  = require("cjson");

_M.ocsp_get = function ()
	local key = "suma_ocsp_ri";
	local cache_ngx   = ngx.shared.ngx_share_dict;
	local ocsp_data   = cache_ngx:get (key);
	if ocsp_data ~= nil then
		return ocsp_data
	end

	local newval, err = cache_ngx:incr(key .. ".lock",1, 0, 1); --- 自悬锁
	if tonumber(newval) > 1 then
		local limit_v = 10;
		local n       = 0;
		while n < limit_v do
			ocsp_data = cache_ngx:get (key);
			if ocsp_data ~= nil then
				return ocsp_data;
			else
				ngx.sleep(0.01);
			end
			n = n+1;
		end
	end
	
	local redis     = require("suma_apollo_redis");
	local red   	= redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip");
	local ok, err   = red:connect(proxy_ip, 6379);

	if not ok then  
		ngx.log(ngx.ERR, "connect to redis error : " , err)
		red:close();
		return nil;
	end
	----请求redis
	local res = red:get(key) ;

	red:close();
	if tostring(res) ~= "userdata: NULL" then
		if res then
			cache_ngx:set(key, res, 300);
		end
		return res
	end
	return nil;
end


_M.allowInstall = function ()
	local state = require("suma_main_state");
	if state.ocsp_option.status then
		return true;
	end
	return false;
end

_M.handle = function (node)
	local ocsp_res   = nil;
	local ocsp_state = false;
	if node.extensions ~= nil then
		for t_k,t_v in pairs(node.extensions)  do
		   local infos = t_v.drmServerInfos;
		   if infos ~= nil then
				for i, v in ipairs (infos) do
					if v.drmServerID == _M.g_server_id then
						ocsp_state = v.ocspState;
					end
				end
		   end
		   local b64_authenticationDatas = t_v.authenticationData;
		   ngx.log(ngx.ERR, "b64_authenticationDatas=" .. b64_authenticationDatas)
		   if b64_authenticationDatas ~= nil then
			   ngx.ctx.authenticationDatas = b64_authenticationDatas;
		   end
		end
    end
	if ocsp_state ~= true then
		ocsp_res = _M.ocsp_get();
		if not ocsp_res then
			return nil;
		end
	end
	return ocsp_res;
end
return _M;