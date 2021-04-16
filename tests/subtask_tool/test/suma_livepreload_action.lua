local cjson   = require("cjson");
local dyn_lib = require("suma_basecom_action");
local http    = require("http");

_M = {}


_M.allowInstall = function ()
	local state = require("suma_main_state");
	if state.preload_option.url then
		_M.preload_url = state.preload_option.url;
	end

	if state.preload_option.status then
		return true;
	end
	
	return false;
end

_M.handle = function (node)
	local pack = {
		["deviceID"] = ngx.ctx.deviceID,
		["contentID"]= node.contentIDs
	};

	local params = {
		method     = "POST",
		ssl_verify = false ,
		body       = cjson.encode(pack),
		headers    = {
            ["Content-Type"] =  "application/json"
        }
	}
	
	local httpd   	  = http.new() ;
	local rres, rerr  = httpd:request_uri(_M.preload_url, params) ;
	 
	if rerr ~= nil then 
		ngx.log(ngx.ERR, "pack all::" .. rerr )
	end
	 
	if nil ~= rres then
		ngx.log(ngx.ERR , "live preload res=" .. rres.body);
		local item = cjson.decode (rres.body)
		if item.base64License  then
			return item.base64License;
		end
	end
	return nil;
end


return _M;