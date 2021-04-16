
local cjson    = require("cjson");
local http     = require("http");
local default_r= require("suma_default_response");

local  _M = {
    ["VERSION"] = "v1.0.0.1"
}

_M.default_response_print = default_r.response;

--- 获取subtask集群地址
_M.get_subtask_base_path = function ()
    return "http://127.0.0.1:10081/"
end

_M.verify = function (content)
    local pack = {
		["source"] = content
	};

    local params = {
        method     = "POST",
        ssl_verify = false ,
        body       = cjson.encode(pack),
        headers    = {
            ["Content-Type"] =  "application/json"
        }
    }

    local httpd     = http.new() ;
    local rres, rerr= httpd:request_uri(_M.get_subtask_base_path() ..
                      "verifySignature?biz_id=basecomponet", params);

    if rerr ~= nil then
        ngx.log(ngx.ERR, rerr);
        return nil;
    end

    local json_p = nil;
    pcall(function ()
        json_p = cjson.decode(rres.body);
    end);

    if json_p ~= nil then
        return json_p;
    end
    return json_p;
end

_M.verify_chain = function (content)
    local pack = {
		["source"] = content
	};

    local params = {
        method     = "POST",
        ssl_verify = false ,
        body       = cjson.encode(pack),
        headers    = {
            ["Content-Type"] =  "application/json"
        }
    }

    local httpd     = http.new() ;
    local rres, rerr= httpd:request_uri(_M.get_subtask_base_path() ..
                      "verify?biz_id=basecomponet", params);

    if rerr ~= nil then
        ngx.log(ngx.ERR, rerr);
        return nil;
    end

    local json_p = nil;
    pcall(function ()
        json_p = cjson.decode(rres.body);
    end);

    if json_p ~= nil then
        return json_p;
    end
    return json_p;
end

_M.signature = function (content)
    local pack = {
		["source"] = content
	};

    local params = {
        method     = "POST",
        ssl_verify = false ,
        body       = cjson.encode(pack),
        headers    = {
            ["Content-Type"] =  "application/json"
        }
    }

    local httpd     = http.new() ;
    local rres, rerr= httpd:request_uri(_M.get_subtask_base_path() ..
                      "sign?biz_id=basecomponet", params);

    if rerr ~= nil then
        ngx.log(ngx.ERR, rerr);
        return nil;
    end

    if rres.status == 200 then
        return rres.body;
    end
    return nil;
end

_M.pack_license = function (node, packer)
    ngx.log(ngx.ERR, "dynamic lib pack_license .");
	local content   = cjson.encode(packer);
	local params = {
	   method     = "POST",
	   ssl_verify = false ,
	   body       = ""
	}
	params.headers = {
		["Content-Type"] =  "application/json"
	};
	params.body      = content;
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri( _M.get_subtask_base_path() ..
                       "pack_license?biz_id=basecomponet", params) ;
	-- ngx.log(ngx.ERR, rres.body);
	-- ngx.log(ngx.ERR , params.body);
    if rerr ~= nil then
        ngx.log(ngx.ERR, rerr);
        return nil;
    end
	local ttt = {};
	if nil ~= rres then
		local item = cjson.decode (rres.body)
		if item.code ~= "000" then
			if ngx.ctx.status == "success" then
				ngx.ctx.status = item.details;
			end
			_M.default_response_print();
			ngx.exit(200);
			return;
		end

		if item.protectedLicenses ~= nil then
			ttt = item.protectedLicenses;
		else
			ngx.log(ngx.ERR, "pack listence is block1");
			if ngx.ctx.status == "success" then
				ngx.ctx.status = "abort";
			end
			--ngx.log(ngx.ERR, rres.body);
			_M.default_response_print();
			ngx.exit(200);
		end
		return ttt
	end
	--end
	ngx.log(ngx.ERR, "pack listence is block2");
	if ngx.ctx.status == "success" then
		ngx.ctx.status = "abort";
	end
	_M.default_response_print();
	ngx.exit(200);
	return ttt;
end

return _M;