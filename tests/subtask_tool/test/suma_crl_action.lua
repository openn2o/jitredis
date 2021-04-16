--
-- CRL 处理
--
local cjson   = require("cjson");
local dyn_lib = require("suma_basecom_action");
local http    = require("http");
local cache_ngx = ngx.shared.ngx_share_dict;
local _M = {}
_M.crl_url = nil;
_M.crl_failed   = false;
_M.allowInstall = function ()
	local state = require("suma_main_state");
	
	if state.crl_option.url then
		_M.crl_url =  state.crl_option.url;
	end

	if state.crl_option.status then
		return true;
	end
	
	return false;
end

_M.handle = function (deviceId)
	if _M.crl_failed  then
		return ;
	end
	local key = deviceId .. "crl";
	if cache_ngx:get(key, 1) then
		return;
	end
	local redis     = require("suma_apollo_redis");
	local red   	= redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip");
	local ok, err   = red:connect(proxy_ip, 6379);

	if not ok then   ---连接失败正常访问
		ngx.log(ngx.ERR, "connect to redis error : " , err)
		red:close();
		return ;
	end
	local res = red:get(key) ;
	red:close();

	if tostring(res) == "userdata: NULL" then --代表 CRL 服务过期清空
		local params = {
			method     = "POST",
			ssl_verify = false
		 }
		 params.headers = {};
		 params.headers ["Content-Type"]  = "application/json";
		 local pack = {};
		 pack.deviceID= deviceId;
		 pack.cert    = ngx.ctx.cert;
		 
		 params.body= cjson.encode(pack);
		 
		 local auth_url   = _M.crl_url .. "verify_crl";
		 local httpd   	  = http.new();
		 httpd:set_timeout(100);
		 local rres, rerr = httpd:request_uri(auth_url, params) ;
		 if rerr then
			 ngx.log(ngx.ERR, rerr);
			 _M.crl_failed = true;
			 return;
		 end
		 if nil ~= rres then
			 local data = cjson.decode(rres.body);
			 if data.code == 2 then
				 if ngx.ctx.status == "success" then
					 ngx.ctx.status = "abort";
				 end
				 dyn_lib.default_response_print();
				 ngx.log(ngx.ERR, "crl block request");
				 ngx.exit(200);
				 return ;
			 end
		 end
		 return;
	end

	if res == 2 then
		if ngx.ctx.status == "success" then
			ngx.ctx.status = "abort";
		end
		_M.default_response_print();
		ngx.log(ngx.ERR, "crl block request");
		ngx.exit(200);
	end

	cache_ngx:set(key, 1, 36000);
end
return _M;