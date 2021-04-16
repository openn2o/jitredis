
local cjson   = require("cjson");
local http    = require("http");
local isub    = string.sub;
local ilen    = string.len;

local dyn_lib = require("suma_basecom_action");

_M = {
	["aaa_url"] = "http://127.0.0.1/"
}
_M.allowInstall = function ()
	local state = require("suma_main_state");
	if state.aaa_option.url then
		_M.aaa_url = state.aaa_option.url;
	end

	if state.aaa_option.status then
		return true;
	end
	
	return false;
end


_M.handle = function (node)
	ngx.log(ngx.ERR, "aaa-get is run.");
	local cache_ngx = ngx.shared.ngx_share_dict;
	local cache     = cache_ngx:get(node.deviceID .. table.concat(node.contentIDs) ..  ".aaa");
	if cache ~= nil then
		return cache;
	end

	----AAA 请求封装
	local creq = {
		["type"]    = "contentRightsRequest",
		["version"] = "1.0",
		["drmServerID"] = ngx.ctx.g_server_id ,
		["drmClientID"] = node.deviceID,
		["contentIDs"]  = node.contentIDs,
		["certificateChain"] = ngx.ctx.g_certificate_chain,
		["selectedAlgorithm"]= ngx.ctx.g_selectedAlgorithm,
		["nonce"] = node.nonce
	}
	
	local str_req = cjson.encode(creq) ;
	local n_str   = isub(str_req,1,ilen(str_req)-1);
	local sign    = n_str .. ",\"signature\":\"\"}";
	str_req = n_str .. ",\"signature\":\"".. dyn_lib.signature(sign).."\"}";


	local params = {
		method     = "POST",
		ssl_verify = false
	}
	 
	params.headers = {};
	params.headers ["Content-Type"]  = "application/json";
	params.body= str_req ;
	 
	local auth_url   = _M.aaa_url .. "get_rules";
	local httpd   	  = http.new() ;
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	if rres ~= nil then
		if nil ~= rres.body then
			local aaa_cjson = nil;
			pcall (function () 
				aaa_cjson = cjson.decode(rres.body);
			end)

			if aaa_cjson == nil then
				return nil;
			end
			ngx.log(ngx.ERR, "aaa-res=" .. rres.body);
			cache_ngx:set(node.deviceID .. table.concat(node.contentIDs) .. ".aaa", rres.body ,1);
			return rres.body
		end
	end
	ngx.log(ngx.ERR, "aaa error.");
	return nil;
end


return _M;