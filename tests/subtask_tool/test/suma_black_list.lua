
local cjson = require("cjson");
local http  = require("http"); 

local _M = {}

_M.verison = "0.0.1";

_M.build_black_list_item_key = function (k) 
	return "black_list/" .. k;
end

_M.forbid = function (k)
	ngx.log(ngx.ERR, " forbid ");
	local key = _M.build_black_list_item_key (k)
	local cache_ngx = ngx.shared.ngx_share_dict;
	return cache_ngx:get(key) == nil ;
end

local ping_enc = require("suma_ping");

_M.fetch_black_list = function () 
	
	
	if ping_enc ~= nil then
		ping_enc.ping();
	end
	
	--ngx.log(ngx.ERR, " run fetch black_list ");
	local params = {  
	   ssl_verify = false,
	   method     = "POST"
	}
	
	local pack = {}
	pack.type  = "ri";
	params.headers = {};
	params.headers ["Content-Type"]  = "application/json";
	params.body= cjson.encode(pack);
	
	local auth_url   = "http://127.0.0.1:9527/get_white_list";
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	
	if rres ~= nil then
		if nil ~= rres.body then
			--ngx.log(ngx.ERR, "blacklist=" .. rres.body);
			
			local data  = cjson.decode(rres.body);
			
			if data["code"] and data["code"] == "000" then
				if data["value"] ~= nil then
					local cache_ngx = ngx.shared.ngx_share_dict;
					for i, v in ipairs (data["value"]) do
						cache_ngx:set(_M.build_black_list_item_key (v), 1 , 60);
						--ngx.log(ngx.ERR, "black_list k" .. v .. " is ok");
					end
				end
			else
				if data["details"] then
					-- ngx.log(ngx.ERR, "blacklist err" .. data["details"]);
					return;
				end
				
				ngx.log(ngx.ERR, "blacklist err unknow");
				return;
			end
		end
	end
	
	if rerr ~= nil then
		-- ngx.log(ngx.ERR, "blacklist err " .. rerr);
	end
	
end


_M.start = function ()
	local worker_id  = ngx.worker.id();	
	if worker_id == 0 then
		local ok, err = ngx.timer.every(1, 
		_M.fetch_black_list );
	end
end

return _M;