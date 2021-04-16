--
-- Verify 验签签名处理
--

local _M = {}
_M.allowInstall = function ()
	local state = require("suma_main_state");
	if state.verify_option.status then
		return true;
	end
	return false;
end

local dyn_lib = require("suma_basecom_action");

_M.handle = function (body)
	local key = ngx.ctx.deviceID .. ".chain";
	local cache_ngx     = ngx.shared.ngx_share_dict;
	local chain_state   = cache_ngx:get (key);
	local verify_result = nil;
	if chain_state == nil then
		verify_result = dyn_lib.verify_chain(body);
		if verify_result.code == "000"  then
			local cache_ngx = ngx.shared.ngx_share_dict;
			cache_ngx:set(ngx.ctx.deviceID .. ".chain" , 1);
		end
	else
		verify_result = dyn_lib.verify(body);
	end

	if verify_result.code ~= "000"  then
		if ngx.ctx.status == "success" then
			ngx.ctx.status = verify_result.details;
		end
		dyn_lib.default_response_print();
		ngx.exit(200);
	end
end
return _M;