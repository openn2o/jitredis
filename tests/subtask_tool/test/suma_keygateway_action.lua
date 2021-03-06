--
-- key gateway 网关请求处理器
--

local cjson    = require("cjson");
local isub 	   = string.sub;
local ilen     = string.len;
local gconcat  = table.concat;
local dyn_lib  = require("suma_dyn_lib");
local http     = require("http");
local _M = {}
_M.verify_chain = dyn_lib.verify_chain;
_M.verify       = dyn_lib.verify;
_M.signature    = dyn_lib.signature;
_M.pack_license = dyn_lib.pack_license;
_M.key_req_send = function (content, pack)
	local params = { 
	    method     = "POST",
	    ssl_verify = false
	}
	params.headers = {};
	params.headers ["Content-Type"]  = "application/json";
	params.body= pack;
	
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(dyn_lib.get_subtask_base_path() .. "kgw/get_key?biz_id=keygateway",params);
	if rres ~= nil then
		if nil ~= rres.body then
			ngx.log(ngx.ERR, "kgw response=" .. rres.body);
			local ecek_result = cjson.decode(rres.body);
			if ecek_result.status ~= "success" then
				ngx.ctx.status = "contentIDNotFound";
				dyn_lib.default_response_print();
				ngx.exit(200);
				return;
			end
			return rres.body
		end
	end
	ngx.log(ngx.ERR, "err:500 key gate way : " .. rerr);
	ngx.exit(500);
	return nil;
end

_M.allowInstall = function ()
   return true;
end

_M.get_content_id_from_req  = function (node)
    local content_id = nil;
    if nil ~= ngx.ctx.contentID then
        content_id = ngx.ctx.contentID;
    else
        content_id = node.contentIDs;
    end
    local contents_ids =  {};
	local time_curr    =  "";
	local time_end     =  "";

    if ngx.ctx.authenticationDatas ~= nil then
		local json_str = ngx.decode_base64(ngx.ctx.authenticationDatas);
		local data     = nil;
		pcall(function ()
			data = cjson.decode(json_str);
		end)
		if data ~= nil then
			if data.cekTime then
				time_curr = data.cekTime .. "";
			end
		end
	end
    for k, v in ipairs(content_id) do
        --防止realloc优化
        local oneContent = {
            ["contentID"] = "",
            ["startTime"] = "",
            ["endTime"]   = ""
        };
        oneContent.contentID = v;
        oneContent.startTime = time_curr;
        oneContent.endTime   = time_end;
        contents_ids[k]      = oneContent;
    end
    return contents_ids;
end


_M.handle = function (node)
    ngx.log(ngx.ERR, "get_ecek_from_key_gate");
    local contentIds = _M.get_content_id_from_req(node);
    local ecek_req = {
		["version"] 		     = "1.0" ,
		["type"]   			     = "keyRequest",
		["contentIDs"]  	     = contentIds,
		["drmServerID"] 	     = ngx.ctx.g_server_id,
		["certificateChain"]     = ngx.ctx.g_certificate_chain,
		["selectedAlgorithm"]    = ngx.ctx.g_selectedAlgorithm,
		["drmClientCertificate"] = node.certificateChain[1],
		["nonce"] 				 = node.nonce
	};
	local str_req = cjson.encode(ecek_req) ;
	local str_nstr= isub(str_req,1,ilen(str_req)-1);
	local sign    = str_nstr .. ",\"signature\":\"\"}";
	ngx.log(ngx.ERR, "send ecek=" .. str_req);
	local str_signed = _M.signature(sign);
	if str_signed == nil then
		ngx.log(ngx.ERR, "\n\n[error] sign error \n\n")
		ngx.exit(500);
		return;
	end
	return  _M.key_req_send(node, table.concat({str_nstr, ",\"signature\":\"", str_signed, "\"}"}));
end

return _M;