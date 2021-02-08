-----
---  New RI Service 
---  agent.zy
--   1202 增加extkey m3u8 -> pssh 获取授权和秘钥
-----
local cjson = require("cjson");
local http  = require("resty.http"); 
local c_decode = cjson.decode;

local isub = string.sub;
local ilen = string.len;
local gconcat = table.concat;

local black_list_m = require("suma_black_list");
---local suma_c_api= require "ngx_suma_c_api"

local _M = {};
--_M.HOST="http://192.166.64.22:9530/"
_M.AAAGATE    = "http://127.0.0.1:9531/"
--_M.KEYGATE  = "http://127.0.0.1:8095/"
_M.KEYGATE    = "http://127.0.0.1:8095/"
_M.HOST       = "http://127.0.0.1"
_M.HOST2      = "http://10.254.12.11"
_M.CRL_HOST   = "http://192.166.64.22:9533/"
_M.REDIS_HOST = "127.0.0.1";

_M.g_server_id = nil;
_M.certificateChain = nil;
_M.g_selectedAlgorithm = nil;
local rand = math.random;

local  base_componet_paths    = {};
base_componet_paths[1] = _M.HOST  .. ":9801/";
-- base_componet_paths[2] = _M.HOST  .. ":9802/";
-- base_componet_paths[3] = _M.HOST  .. ":9803/";
base_componet_paths[2] = _M.HOST2  .. ":9801/";
local  max_client = 0;

_M.get_base_componet_path2 = function () 
	return base_componet_paths[1];
end

_M.get_base_componet_path = function () 
	return base_componet_paths[1];
	-- local rd = rand(100);
	-- if rd < 60 then
	-- 	return  base_componet_paths[1];
	-- end
	-- return  base_componet_paths[2];
end


local KEY_GATE_WAY_RAW =  _M.KEYGATE .. "kgw/get_key";
_M.key_req_send = function (content, pack)
	local cache_ngx = ngx.shared.ngx_share_dict;

	local params = {  
	    method     = "POST",
	    ssl_verify = false
	}
	local auth_url   = KEY_GATE_WAY_RAW ;
	params.headers = {};
	params.headers ["Content-Type"]  = "application/json";
	params.body= pack; --cjson.encode(pack);
	
	
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	-- httpd:set_keepalive(1, 30000)
	if rres ~= nil then
		if nil ~= rres.body then
			local ecek_result = cjson.decode(rres.body);
			
			if ecek_result.status ~= "success" then
				ngx.ctx.status = "contentIDNotFound";
				_M.default_response_print();
				ngx.exit(200);
				return;
			end
			
			local value = cache_ngx:set(content.deviceID .. content.contentIDs[1] .. #content.contentIDs .. ".kgw",  rres.body, 1);  --10min
			--local data  = cjson.decode(rres.body);
			--if data.keyGateWayID ~= nil then
				--ngx.ctx.serverid = data.keyGateWayID;
			--end
			--ngx.log(ngx.ERR , rres.body);
			return rres.body
		end
	end
	ngx.log(ngx.ERR, "err:500 key gate way : " .. rerr);
	ngx.log(ngx.ERR, rres);
	ngx.exit(500);
	return nil;
end


local template = require("suma_apollo_template");

local cencode = cjson.encode;
_M.pack_license = function (node, packer) 
	local cache_ngx = ngx.shared.ngx_share_dict;
	local cache     = cache_ngx:get(node.deviceID .. node.contentIDs[1]  .. #node.contentIDs);

	-- if cache ~= nil then
	-- 	return cjson.decode(cache);
	-- end
	
	local content = cencode(packer);
	--ngx.log(ngx.ERR, "license = " .. content);

	local params = {  
	   method     = "POST",
	   ssl_verify = false ,
	   body       = ""
	}
	
	params.headers = {
		["Content-Type"] =  "application/json"
	};
	-- params.headers ["Content-Type"]  = "application/json";
	params.body = content;
	
	local auth_url   = _M.get_base_componet_path() .. "pack_license" ;
	local httpd   	 = http.new() ;
	-- httpd:set_keepalive(1, 30000)
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	--if rres ~= nil then
	-- ngx.log(ngx.ERR, rres.body);
	-- ngx.log(ngx.ERR , params.body);
	local ttt = {};
	if nil ~= rres then
			
		local item = cjson.decode (rres.body)
		if item.code ~= "000" then
			ngx.log(ngx.ERR, "err=>" .. rres.body );
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
		-- ttt = item.protectedLicenses;
		-- if (ilen(rres.body) > 30) then
		-- 	ttt = item.protectedLicenses;
		-- else
		-- 	ngx.log(ngx.ERR, "pack listence is block");
		-- 	if ngx.ctx.status == "success" then
		-- 		ngx.ctx.status = "abort";
		-- 	end
		-- 	--ngx.log(ngx.ERR, rres.body);
		-- 	_M.default_response_print();
		-- 	ngx.exit(200);
		-- 	return ttt;
		-- end
			
		--ngx.log(ngx.ERR, "license" .. tostring(item.details));
		cache_ngx:set(node.deviceID .. node.contentIDs[1]  .. #node.contentIDs , cencode(ttt) , 1);
		return ttt
		-- end
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


_M.verify_chain = function (content)

	local params = {
	   method     = "POST",
	   ssl_verify = false ,
	   body       = ""
	}
	
	params.headers = {
		["Content-Type"] =  "application/json"
	};
	-- params.headers ["Content-Type"]  = "application/json";
	
	local pack = {
		["source"] = content
	};
    
	--content = string.gsub(content, "\"", "%\\"");
	params.body= cjson.encode(pack);
	--params.body = [[{"source":"]].. content ..[["}]];
	--ngx.log(ngx.ERR, params.body);
	local auth_url   = _M.get_base_componet_path () .. "verify";
	local httpd   	 = http.new() ;
	-- httpd:set_keepalive(1, 30000)
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	--if rres ~= nil then
	
	if rerr ~= nil then 
		ngx.log(ngx.ERR, "_M.verify_chain::" .. rerr )
	end
	if nil ~= rres then
		--ngx.log(ngx.ERR, "verify" .. rres.body);
		
		-- verify_result.code == "000"
		return rres.body
	end
	--end
	return nil;
end


_M.verify = function (content)
	local params = {
	   method     = "POST",
	   ssl_verify = false ,
	   body       = ""
	}
	
	params.headers = {
		["Content-Type"] =  "application/json"
	};
	
	
	local pack = {
		["source"] = content
	};
    
	--content = string.gsub(content, "\"", "%\\"");
	params.body= cjson.encode(pack);
	--params.body = [[{"source":"]].. content ..[["}]];
	--ngx.log(ngx.ERR, params.body);
	--local auth_url   = "http://192.166.64.22:9555/verify";
	local auth_url   = _M.get_base_componet_path () .. "verifySignature";
	local httpd   	 = http.new() ;
	-- httpd:set_keepalive(1, 30000)
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	--if rres ~= nil then
	if rerr ~= nil then
		ngx.log(ngx.ERR, "verify::" .. rerr )
	end
	if nil ~= rres then
		--ngx.log(ngx.ERR, "verify" .. rres.body);
		return rres.body
	end
	--end
	return nil;
end


-- local g_header = {}

-- g_header ["Content-Type"]  = "application/json";
--[[签名--]]
_M.signature = function (content)


	local params = {
	   method     = "POST",
	   ssl_verify = false ,
	   body       = ""
	}
	
	params.headers = {
		["Content-Type"] =  "application/json"
	};

	local pack = {
		["source"] = content
	};
	params.body= cjson.encode(pack);
	local auth_url   = _M.get_base_componet_path () .. "sign";
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	if nil ~= rres then
		return rres.body
	end
	ngx.log(ngx.ERR, "sign error::" .. rerr)
	return nil;
end

local csignature = _M.signature;
--[[
mock ecek request
--]]

--_M.g_certificateChain    = {}
--_M.g_certificateChain[1] = [[MIIBvDCCAWGgAwIBAgIEEtXjITAKBggqgRzPVQGDdTA0MQswCQYDVQQGDAJDTjENMAsGA1UECgwEQ0RUQTEWMBQGA1UEAwwNRFJNIFNlcnZlciBDQTAeFw0xOTA1MDUwNzAwMDBaFw0yNDA1MDYwNjU5NTlaMD8xCzAJBgNVBAYMAkNOMRQwEgYDVQQKDAtTdW1hIFZpc2lvbjEaMBgGA1UEAwwRQ0RSTS1QT0MtS01TLVNVTUEwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAARL/2NUqsGZK+4vfkdtTogQuMlpxUiG/grZw/88IssvvZvRu4ZNh6QQu2XbupggOj9F7dQevOpA/NhfMZO7eUXOo1YwVDAOBgNVHQ8BAf8EBAMCB4AwFQYDVR0lAQH/BAswCQYHKoEchu8wFzArBgNVHSMEJDAigCCoXjDqV093IYgV+10OcAxe/hMvkFAT2JbGzeCG1j8ONzAKBggqgRzPVQGDdQNJADBGAiEAtSsi8IMaOBV12aVq3/UkvAU+8cC0YUz0Eg5GVd7jTwACIQDkVu8tkLFj5wgLhjHMKf5qaE9FnZG+kryWi9qCdVJ4qg==]] 
--_M.g_certificateChain[2] = [[MIIB1TCCAXqgAwIBAgIEPpdMHjAKBggqgRzPVQGDdTAuMQswCQYDVQQGDAJDTjENMAsGA1UECgwEQ0RUQTEQMA4GA1UEAwwHUm9vdCBDQTAgFw0xOTA1MDUwNzAwMDBaGA8yMDY5MDUwNjA2NTk1OVowNDELMAkGA1UEBgwCQ04xDTALBgNVBAoMBENEVEExFjAUBgNVBAMMDURSTSBTZXJ2ZXIgQ0EwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAATBrbIBDT0ZVzSujLTaN+M/6kNFJnBHf+ON4h4Td3ecuqDs3OsX8lzCe2ps3Q9GgkOlTdQvDn0EDc05/Nr93X9Io34wfDApBgNVHQ4EIgQgqF4w6ldPdyGIFftdDnAMXv4TL5BQE9iWxs3ghtY/DjcwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwKwYDVR0jBCQwIoAg/gShDd110f1FY3fkB+CnCG3gVNkdP8YZv8jbk5SCNNEwCgYIKoEcz1UBg3UDSQAwRgIhAMryOGAga/re2g90+UM9y/tyP4u/TmjP2i1M0BW5vrxiAiEAo/3pXEtWM1z1VbdeV39uGZDmdNSSmLiKhLvz1MvS0hE=]]
--未优化
_M.get_acc_from_aaa_gate = function (node, contentIds)
	
	local cache_ngx = ngx.shared.ngx_share_dict;
	local cache     = cache_ngx:get(node.deviceID .. "aaa");
	if cache ~= nil then
		return cache;
	end
	local  d = {};
	d.type = "contentRightsRequest";
	d.version =  "1.0";
	d.drmServerID          = _M.g_server_id;
	d.drmClientID          = node.deviceID;
	
	
	local tmp = {};
	for i, v in ipairs(contentIds) do
		tmp[i] = v.contentID;
	end
	d.contentIDs           = tmp;
	d.certificateChain     = _M.certificateChain;
	d.selectedAlgorithm    = _M.g_selectedAlgorithm;
	d.nonce 			   = node.nonce;
	
	
	local str_req = cjson.encode(d) ;
	local n_str   = isub(str_req,1,ilen(str_req)-1);
	local sign    = n_str .. ",\"signature\":\"\"}";
	str_req = n_str .. ",\"signature\":\"".._M.signature(sign).."\"}";
	
	ngx.log(ngx.ERR, "AAA_req" .. str_req);
	
	
	local params = {  
	   method     = "POST",
	   ssl_verify = false
	}
	
	params.headers = {};
	params.headers ["Content-Type"]  = "application/json";
	params.body= str_req ;
	
	local auth_url   = _M.AAAGATE .. "get_rules";
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	if rres ~= nil then
		if nil ~= rres.body then
			ngx.log(ngx.ERR, "aaa-res=" .. rres.body);
			--local value = cache_ngx:set(content.deviceID, rres.body, 1);  --10min
			--local data  = cjson.decode(rres.body);
			--if data.keyGateWayID ~= nil then
				--ngx.ctx.serverid = data.keyGateWayID;
			--end
			--ngx.log(ngx.ERR , rres.body);
			cache_ngx:set(node.deviceID .. "aaa", rres.body ,1);
			return rres.body
		end
	end
	ngx.log(ngx.ERR, "err:500 aaa gate way" .. rerr);
	--ngx.exit(500);
	
	return ""
end

_M.get_ecek_from_key_gate  = function (node, contentIds) 
	local cache_ngx = ngx.shared.ngx_share_dict;
	local cache     = cache_ngx:get(node.deviceID .. node.contentIDs[1] .. #node.contentIDs .. ".kgw");
	
	-- if cache ~= nil then
	-- 	return cache;
	-- end
	
	local  d = {
		["type"]    =  "keyRequest",
		["version"] =  "1.0" ,
		["drmServerID"] = _M.g_server_id,
		["contentIDs"]  = contentIds,
		["certificateChain"] = _M.certificateChain,
		["drmClientCertificate"] = node.certificateChain[1],
		["selectedAlgorithm"]    = _M.g_selectedAlgorithm,
		["nonce"] = node.nonce
	};
	-- d.type = "keyRequest";
	-- d.version =  "1.0";
	-- d.drmServerID          = _M.g_server_id;
	-- d.contentIDs           = contentIds;
	-- d.certificateChain     = _M.certificateChain;
	-- d.drmClientCertificate = node.certificateChain[1];
	-- d.selectedAlgorithm    = _M.g_selectedAlgorithm;
	-- d.nonce 			   = node.nonce;
	-------------------------------减少relloc的次数
	
	
	local str_req = cjson.encode(d) ;
	
	ngx.log(ngx.ERR, str_req);
	local n_str   = isub(str_req,1,ilen(str_req)-1);
	local sign    = n_str .. ",\"signature\":\"\"}";
	
	local __sign = csignature(sign);
	if __sign == nil then
		ngx.log(ngx.ERR, "\n\n[error] __sign error \n\n")
		ngx.exit(500);
		return;
	end
	
	str_req = gconcat({ n_str , ",\"signature\":\"", __sign, "\"}"});
	local str = _M.key_req_send (node, str_req);
	-- ngx.log(ngx.ERR, "ecek" .. str);
	return str;
end

local __exit = ngx.exit;
local SIZE_TIME_CORRECT = 3600;
local NEXT_DAY_SEC      = 86400;

--- 请求content id [ok] --防止realloc优化
_M.get_content_id_from_req = function (node) 
	local eax = nil;
	if ngx.ctx.contentID ~= nil then
		eax = ngx.ctx.contentID;
		-- ngx.log(ngx.ERR, ngx.ctx.contentID)
	else 
		eax = node.contentIDs;
	end
	
	local contents_ids = {};
	local time_curr = ngx.time() .. "";
	local time_end  = (time_curr + NEXT_DAY_SEC ).. ""; -- NEXT_DAY_SEC
	for k, v in ipairs(eax) do
		--if v ~= nil then
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
		--end
	end
	return contents_ids;
end

--- 请求时间 [ok]
_M.check_time_correct = function (check_time) 
	return true;
	-- if not check_time then
	-- 	return false
	-- end
	
	-- local time_t = ngx.time()
	
	-- if (check_time > time_t  - SIZE_TIME_CORRECT) and
	--    ( check_time < time_t + SIZE_TIME_CORRECT) then
	-- 	return true
	-- end
	-- return false
end

local cache_ngx = ngx.shared.ngx_share_dict;
----
---- 距离优化
_M.get_share_dict_data = function (key) 
    return  cache_ngx:get(key);
end


local func_get_share_dict_data = _M.get_share_dict_data;

local cert  = require("suma_cert_module");
local igsub = string.gsub;


local mverify = _M.verify;

_M.default_response_print = function () 
	if not ngx.ctx.nonce then
		ngx.ctx.nonce     = "";
	end
	
	if not ngx.ctx.status then
		ngx.ctx.status   = "malformedRequest";
	end
	
	if not ngx.ctx.deviceID then
		ngx.ctx.deviceID = "";
	end
	
	-----relloc 优化
	local result = {0,0,0,0,0,0,0,0,0,0,0} ;
	result[1] = '{"type":"licenseResponse","version":"2.0","status":"';
	result[2] = ngx.ctx.status
	result[3] = '","selectedAlgorithm":"KMSProfile1","responseTime":"';
	result[4] = ngx.time() ;
	result[5] = '","deviceID":"'
	result[6] = ngx.ctx.deviceID ;
	result[7] = '","drmServerID":"';
	result[8] = _M.g_server_id;
	result[9] =  '","nonce":"';
	result[10] = ngx.ctx.nonce;
	result[11] ='","protectedLicenses":[],"certificateChain":[],"signature":""}'
	
	--local str_req = test ;-- cjson.encode(res) ;
	--local str_req = cjson.encode(res) 
	local  result_str = gconcat(result)
	ngx.log(ngx.ERR, "resp::err" .. result_str);
	ngx.say(result_str);
	ngx.exit(200);
end

--crl check 未优化
_M.crl_check = function (deviceId)
	local key = "suma_crl_" ..  deviceId
	local redis = require("suma_apollo_redis") ;
	local red   = redis:new();
	
	local ok, err = red:connect(_M.REDIS_HOST,  6379) ;
	red:auth("redis");
	if not ok then   ---连接失败正常访问
		ngx.log(ngx.ERR, "connect to redis error : " , err)
		red:close();
		return ;
	end  
	----请求redis
	local res = red:get(key) ;
	red:close();
	
	-- ngx.log(ngx.ERR, "cc=" .. tostring(res))
 	if tostring(res) == "userdata: NULL" then --代表 CRL 服务过期清空
		---开始请求
		-- ngx.log(ngx.ERR, "gogogo");
		
		local params = {
		   method     = "POST",
		   ssl_verify = false
		}
		params.headers = {};
		params.headers ["Content-Type"]  = "application/json";
		
		
		local pack = {};
		--content = isub (content,1,ilen(content)-2);
		--content = string.gsub(content, "%\\%/", "%/");
		pack.deviceID= deviceId;
		pack.cert    = ngx.ctx.cert;
		
		params.body= cjson.encode(pack);
		
		local auth_url   = _M.CRL_HOST .. "verify_crl";
		local httpd   	 = http.new() ;
		local rres, rerr = httpd:request_uri(auth_url, params) ;
		--if rres ~= nil then
		if rerr then
			ngx.log(ngx.ERR, rerr)
		end
		if nil ~= rres then
			ngx.log(ngx.ERR, "crl =" .. rres.body);
			local data = cjson.decode(rres.body);
			
			if data.code == 2 then
				ngx.log(ngx.ERR, "crl result2 block");
				
				-- return rres.body
				if ngx.ctx.status == "success" then
					ngx.ctx.status = "abort";
				end
				_M.default_response_print();
				ngx.log(ngx.ERR, "crl block request");
				ngx.exit(200);
				return ;
			end
		end
		--end
		-- return nil;
		return;
		
	end
	
	if res == 2 then
		if ngx.ctx.status == "success" then
			ngx.ctx.status = "abort";
		end
		_M.default_response_print();
		ngx.log(ngx.ERR, "crl block request");
		ngx.exit(200);
		return ;
	end
end
-- ocsp 处理
-- reids   suma_ocsp_ri cache 5分钟周期失效
-- 请求缓存 -> 回源redis -> 存入缓存
_M.ocsp_get = function ()
	local key = "suma_ocsp_ri"
	
	local exists = func_get_share_dict_data(key);
	
	if exists ~= nil then
		return exists
	end
	local cache_ngx   = ngx.shared.ngx_share_dict;
	local newval, err = cache_ngx:incr(key .. ".lock",1, 0, 1); --- 自悬锁
	if tonumber(newval) ~= 1 then
		ngx.sleep(0.1) ; --- sleep 100ms timeout 
		return func_get_share_dict_data(key);
	end
	
	local redis = require("suma_apollo_redis") ;
	local red   = redis:new();
	
	local ok, err = red:connect(_M.REDIS_HOST,  6379) ;
	red:auth("redis");
	if not ok then  
		ngx.log(ngx.ERR, "connect to redis error : " , err)
		red:close();
		return "";
	end  
	
	----请求redis
	local res = red:get(key) ;
	red:close();
	if res ~= nil then
		local cache_ngx = ngx.shared.ngx_share_dict;
		local value     = cache_ngx:set(key, res, 300);
		return res
	end
	return "";
end

local bodyReader = ngx.req.read_body;


_M.DRM_SYSTEM_ID = {
	[ "61941095315515465232184672216011011419644" ] = function (param) 
		---china drm
		ngx.log(ngx.ERR, "china drm rrotate");
		if param.contentID ~= nil then
			if ngx.ctx.contentID == nil then
				ngx.ctx.contentID = {};
			end
			ngx.ctx.contentID[#ngx.ctx.contentID + 1] = param.contentID;
			ngx.log(ngx.ERR, "add contentID=" .. param.contentID);
			return true;
		end
		return false
	end
}

function split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
	   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
	   if not nFindLastIndex then
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
		break
	   end
	   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
	   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
	   nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end


_M.pssh_check = function (contentId)
	local dd 	   = contentId;
	local byte_xor = string.byte;
	local obj      = ngx.decode_base64(dd);
	
	local is_m3u8  = string.char(byte_xor(obj,1,8));
	if "#EXT-X-K" ==  is_m3u8 then
		ngx.log(ngx.ERR, " m3u8 => mp4dash");
		local test2 = split (obj, ",");
		local look_up_next = false;
		for i, v in ipairs(test2) do
			if look_up_next then
				ngx.log(ngx.ERR, "pssh data=:" .. v);
				obj = ngx.decode_base64(string.sub(v, 1, #v-1));
				look_up_next = false;
			end
			
			if v == 'URI="data:text/plain;base64' then
				look_up_next = true;
			end
		end
		
		if obj == nil then
			return false;
		end
	end
	-- if (string.byte(obj, 33, 34) == 0x7b) and -- {
	--    (string.byte(obj, tail - 1 , tail) == 0x7d) then -- }
	-- 	-- ngx.log(ngx.ERR, "is a validate JSON");
	-- else
	-- 	return false;
	-- end
	-- ngx.log(ngx.ERR , string.byte(obj,1,#obj));
 --    ngx.log(ngx.ERR, string.byte(obj,1,4));      -- Size 4字节
 --    ngx.log(ngx.ERR, string.byte(obj,5,8));      -- Type 4字节 0x70 73 73 68
 --    ngx.log(ngx.ERR, string.byte(obj,9,10));     -- version 1字节
 --    ngx.log(ngx.ERR, string.byte(obj,11,12));    -- Flags 3字节
 --    ngx.log(ngx.ERR, string.byte(obj,13,28));    -- SystemId 16字节
	-- ngx.log(ngx.ERR, string.byte(obj,29,32));    -- dataSize 4字节
	--类型不对
	
	local  sType   = string.char(byte_xor(obj,5,8)); -- Type 4字节 0x70 73 73 68
	-- ngx.log(ngx.ERR, "pssh = " .. sType);
	if sType ~= "pssh" then  
		return false;
	end
	
	local tail = #obj;
	
	----因为截取的是指针，我们必须把指针转换成字符串
	local buffer = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
	
	for i=1,16,1 do
	   buffer [i] = byte_xor(obj,i+12, i+13);
	end
	
	local system_id = gconcat(buffer);
	-- ngx.log(ngx.ERR, "system_id=" .. system_id);
	----如果不在drm列表内说明没有注册的DRM ID
	if _M.DRM_SYSTEM_ID[system_id] ~= nil then
		local pssh_data = string.char(byte_xor(obj,33,tail));
		local node = nil ;
		-- ngx.log(ngx.ERR, pssh_data)
		pcall(function ()
			node = c_decode(pssh_data);
		end);
		-- ngx.log(ngx.ERR, "node=" .. cjson.encode(node));
		if (node ~= nil) then
			return _M.DRM_SYSTEM_ID[system_id] (node);
		end
	end
	return false;
end

_M.handle = function ()
	
	-- ngx.exit(200);
	-- local args = ngx.req.get_uri_args();
	
	---测试字段
	-- if args and args.test ~= nil then
	-- 	ngx.ctx.test = args.test;
	-- end
	
	ngx.ctx.status = "success"

	if _M.g_server_id == nil then
		_M.certificateChain    = c_decode(func_get_share_dict_data("CertificateChain0"));
		_M.g_server_id		   = func_get_share_dict_data("GetKeyID0");
		_M.g_selectedAlgorithm = func_get_share_dict_data("GetAlgorithm0");
	end
---force request body 
---this was harmful performance
	bodyReader();
	
	local body_str = ngx.req.get_body_data();
	
	if body_str == nil then
		local file_name = ngx.req.get_body_file()
		if file_name then
			body_str = get_file(file_name)
		end
		
		if nil == body_str then
			ngx.exit(ngx.HTTP_BAD_REQUEST);
			return;
		end
	end

	ngx.log(ngx.ERR, "request body" .. body_str);
	local node  = nil;
	local invalidate =  pcall(function () 
		node = c_decode(body_str);
	end);
	

	if node == nil then
		if ngx.ctx.status == "success" then
			ngx.ctx.status = "malformedRequest";
		end
		_M.default_response_print();
		ngx.exit(200);
		return;
	end
	
	-- if not ngx.ctx.test then
	ngx.ctx.deviceID = node.deviceID;
	
	if not node.deviceID then
		ngx.ctx.status = "abort";
		_M.default_response_print();
		ngx.exit(200);
	end
	
	ngx.ctx.nonce    = node.nonce;
	
	if (not node.nonce) or (node.nonce == "") then
		ngx.ctx.status = "abort";
		_M.default_response_print();
		ngx.exit(200);
	end
	
	if (not node.version) or (node.version ~= "2.0") then
		--TODO default 
		if ngx.ctx.status == "success" then
			ngx.ctx.status = "versionNotSupported";
		end
		_M.default_response_print();
		ngx.exit(200);
	end
	
	if (not node.type) or (node.type ~= "licenseRequest") then
		--TODO default 
		if ngx.ctx.status == "success" then
			ngx.ctx.status = "typeNotSupported";
		end
		_M.default_response_print();
		ngx.exit(200);
	end
	
	if (not node.contentIDs) then
		ngx.ctx.status = "contentIDNotFound";
		_M.default_response_print();
		ngx.exit(200);
	end
	
	----多个content ID是PSSHbox 的情况
	----需要多次处理替换原有的ContentID
	-- node.contentIDs[1] = [[AAAAo3Bzc2gAAAAAPV5tNZuaQei4Q908bnLELAAAAIN7InZlcnNpb24iOiJWMS4wIiwiY29udGVudElEIjoiTVRBd01EQXhNREV5TXpRMU5qYzRPUT09Iiwia2lkcyI6WyJOelpsTnpSaU56YzBaREF4TkRSaU1XSXhPRE5tTlRnME1ERTRabVEzTVRrPSJdLCJlbnNjaGVtYSI6ImNlbmMifQ]]
	-- node.contentIDs[2] = [[AAAAtXBzc2gAAAAAPV5tNZuaQei4Q908bnLELAAAAJV7InZlcnNpb24iOiJWMS4wIiwiY29udGVudElEIjoiY0c5cGRXNWlkbUZ6WkdabmFHdHgiLCJraWRzIjpbIk56WmxOelJpTnpjMFpEQXhORFJpTVdJeE9ETm1OVGcwTURFNFptUTNNVGs9Il0sImVuc2NoZW1hIjoic200YyIsImV4dGVuc2lvbnMiOiJzdHJpbmcifQ]]
	for i=1,#node.contentIDs,1 do
	  _M.pssh_check(node.contentIDs[i]);
	end
	
	if (not node.supportedAlgorithms)  or (node.supportedAlgorithms[1] ~= "KMSProfile1") then
		ngx.ctx.status = "abort";
		_M.default_response_print();
		ngx.exit(200);
	end
	
	if (not node.certificateChain ) or (#node.certificateChain < 2) then
		ngx.ctx.status = "invalidCertificateChain";
		_M.default_response_print();
		ngx.exit(200);
	end
	
	local  verify_result = nil;
	if func_get_share_dict_data(ngx.ctx.deviceID .. ".chain") == nil then
		----校验客户端的证书链
		verify_result = _M.verify_chain(body_str);
		if string.find(verify_result , "000") ~= nil  then
			local cache_ngx = ngx.shared.ngx_share_dict;
			cache_ngx:set(node.deviceID .. ".chain" , 1);
		end
	else
		verify_result = mverify (body_str);
	end
	
	if (not verify_result) then
		-- ngx.log(ngx.ERR, "error::failed..")
		if ngx.ctx.status == "success" then
			ngx.ctx.status = "abort";
		end
		_M.default_response_print();
		ngx.exit(200);
	end
	
	verify_result = cjson.decode(verify_result);
	
	if verify_result.code ~= "000" then
		--ngx.log(ngx.ERR, "verify is block");
		if ngx.ctx.status == "success" then
			ngx.ctx.status = verify_result.details;
		end
		_M.default_response_print();
		ngx.exit(200);
	end

	------------------------------------------------------------
	-- local OLD1 = node.deviceID;
	-- local OLD2 = node.nonce;
	-- -- node.deviceID = "RND_" .. math.random(10000);
	-- node.nonce    = node.deviceID;
	
	------------------------------------------------------------
	----- crl 
	-- if node.certificateChain then
	-- 	ngx.ctx.cert = node.certificateChain[1];
	-- 	_M.crl_check(node.deviceID)
	-- end

	-- suma_crl_deviceID
	-- if not black_list_m.forbid(node.deviceID) then
	-- 	if ngx.ctx.status == "success" then
	-- 		ngx.ctx.status = "accessDenied";
	-- 	end
	-- 	ngx.log(ngx.ERR, "black_list block");
	-- 	_M.default_response_print();
	-- 	ngx.exit(200);
	-- end
	
	-- if (_M.check_time_correct(tonumber(node.requestTime)) == false) then
	-- 	ngx.log(ngx.ERR, "request time is not invalidate");
	-- 	if ngx.ctx.status == "success" then
	-- 		ngx.ctx.status = "deviceTimeError";
	-- 	end
	-- end
	
	-- if  ngx.ctx.test then
	-- 	local cache_ngx = ngx.shared.ngx_share_dict;
	-- 	local cache     = cache_ngx:get(node.nonce);
	-- 	if cache ~= nil then
	-- 		ngx.ctx.status = "abort";
	-- 		_M.default_response_print();
	-- 		ngx.exit(200);
	-- 		ngx.log(ngx.ERR, "this is nonce id block.");
	-- 		return cache;
	-- 	end
	-- 	cache_ngx:set(node.nonce, 1);
	-- end
	--local template  = require "resty.template"
	--local render_ri = template.suma_ri_response;
	

	local contentIds = _M.get_content_id_from_req(node);
	local ecek       = _M.get_ecek_from_key_gate (node, contentIds);
	--ngx.log(ngx.ERR, "ecek=" .. ecek);
	if ecek == nil then
		ngx.log(ngx.ERR, "key gate way is block");
		if ngx.ctx.status == "success" then
			ngx.ctx.status = "contentIDNotFound";
		end
		_M.default_response_print();
		ngx.exit(200);
		return;
	end
	
	-- local aaa = _M.get_acc_from_aaa_gate(node, contentIds);
	-- if not aaa then
	-- 	ngx.log(ngx.ERR, "aaa connect failed");
	-- 	ngx.exit(500);
	-- 	return;
	-- end
	
	-- local aaa_result = cjson.decode(ecek);
	
	-- if aaa_result.status ~= "success" then
	-- 	ngx.ctx.status = "abort";
	-- 	_M.default_response_print();
	-- 	ngx.exit(200);
	-- 	ngx.log(ngx.ERR, "aaa failed");
	-- 	return;
	-- end
	
	--[[
	if eax(ecek) ~= '0' then
		ngx.log(ngx.ERR, "key gate way is block");
		ngx.exit(500);
	end
	--]]
	--[[if node.deviceID == nil then
		ngx.log(ngx.ERR, "key gate way is block");
		ngx.exit(500);
		return;
	end
	--]]
		
	--if  not license then
		--ngx.log(ngx.ERR, "ecek" .. ecek);
		--ngx.log(ngx.ERR, "deviceId" ..  node.deviceID);
	--end
	---------------------------------------------------
	---relloc 
	local packer = {
		["drmClientCertificate"] = "",
		["keyResponse"] = "",
		["deviceID"] = ""
	};
	
		---test
	--local  test = [[{"type":"keyResponse","version":"1.0","keyGateWayID":"K5gvdvIqkO15/VyiWA9D1laOmZrLj21YhV+x6iCMw24=","nonce":"kuYqz45291w7hpRnRBONJJOW2UY=","status":"success","selectedAlgorithm":"KMSProfile1","certificateChain":["MIIBujCCAWGgAwIBAgIEIHwhZzAKBggqgRzPVQGDdTA0MQswCQYDVQQGDAJDTjENMAsGA1UECgwEQ0RUQTEWMBQGA1UEAwwNRFJNIFNlcnZlciBDQTAeFw0xOTA1MDUwNzAwMDBaFw0yNDA1MDYwNjU5NTlaMD8xCzAJBgNVBAYMAkNOMRQwEgYDVQQKDAtTdW1hIFZpc2lvbjEaMBgGA1UEAwwRQ0RSTS1QT0MtS0dXLVNVTUEwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAAS+JIbKf7puoYnvCqzmpbV3gax9AdVaLPAMBEWunR7SbfIQO9+yy5t7FKxdgsnAg76OdDTbt3X+TDDeysqmjWc7o1YwVDAOBgNVHQ8BAf8EBAMCB4AwFQYDVR0lAQH/BAswCQYHKoEchu8wGDArBgNVHSMEJDAigCCoXjDqV093IYgV+10OcAxe/hMvkFAT2JbGzeCG1j8ONzAKBggqgRzPVQGDdQNHADBEAiA22S6prBdSVjhg31fFrACZ/wyftPg1YL9f240DEOPrSQIgQ9HXrmK1weF+heckOHdVEP+2TFmJHMvrcVAKzdRMw4g=","MIIB1TCCAXqgAwIBAgIEPpdMHjAKBggqgRzPVQGDdTAuMQswCQYDVQQGDAJDTjENMAsGA1UECgwEQ0RUQTEQMA4GA1UEAwwHUm9vdCBDQTAgFw0xOTA1MDUwNzAwMDBaGA8yMDY5MDUwNjA2NTk1OVowNDELMAkGA1UEBgwCQ04xDTALBgNVBAoMBENEVEExFjAUBgNVBAMMDURSTSBTZXJ2ZXIgQ0EwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAATBrbIBDT0ZVzSujLTaN+M/6kNFJnBHf+ON4h4Td3ecuqDs3OsX8lzCe2ps3Q9GgkOlTdQvDn0EDc05/Nr93X9Io34wfDApBgNVHQ4EIgQgqF4w6ldPdyGIFftdDnAMXv4TL5BQE9iWxs3ghtY/DjcwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwKwYDVR0jBCQwIoAg/gShDd110f1FY3fkB+CnCG3gVNkdP8YZv8jbk5SCNNEwCgYIKoEcz1UBg3UDSQAwRgIhAMryOGAga/re2g90+UM9y/tyP4u/TmjP2i1M0BW5vrxiAiEAo/3pXEtWM1z1VbdeV39uGZDmdNSSmLiKhLvz1MvS0hE="],"signature":"BbXYFe1s572L6dndaE+zyXDtUhrZTNGX64sIOSAJc7MghPTvRC71DqbEpohUjtcBELKBTMqQoeXNaPxvIdEJhw==","cekInfos":[{"contentID":"Um90YUtleUxpdmVTbm0=","sessionKeyID":"uAXDMxEgi77XiyHDJ8QFrA==","encSessionKey":"BJgd3JdXsSooY7T/5GIZitBLM7i+FLf00U6ItsJkDcRNlYgiZUSghWqBNMmrCEBGr9bOUwdQ6Qjz/GDT3iItlINba4DWjRWRWG3CHykBqQw8gl8AbKO9zcyQyxSfs18OyZtnH/SzKIKx6zYdHlXR+p4=","encCEKs":[{"cekID":"YExCgSKD3uniX9sNlLWiRw==","encCEK":"9i2vJxTxzM9USBhVDVwJCA=="},{"cekID":"EGCw+DFXrkfLhPmpqIfhYw==","encCEK":"RAMVDiNVhswF1KUz+8LcDA=="},{"cekID":"RtbY6XyzOh32BdUMLU4Ipw==","encCEK":"5QKH38bOcEGq9bnmcBb2OQ=="}],"contentRules":"BQEEXxekxAIEce+FRAQEAAAAluAEX1X1YOEEX1X3Ig=="}]}]]
	
	packer.drmClientCertificate = node.certificateChain[1];
	packer.keyResponse          = ecek;
	packer.deviceID             = node.deviceID;
	if aaa ~= nil then
		packer.aaaResponse          = aaa;
	end
	local license = _M.pack_license(node, packer);

	--[[
	local license    = suma_c_api.ngx_suma_pack_license(
		node.deviceID,
		ecek
	);

	if  not license then
		ngx.log(ngx.ERR, "ecek" .. ecek);
		ngx.log(ngx.ERR, "deviceId" ..  node.deviceID);
		ngx.exit(500);
		return;
	end
	--]]
	
	---relloc 
	local res  = {
		["version"] = 1,
		["type"]    = 1,
		["status"]  = 1,
		["protectedLicenses"] = 1,
		["responseTime"] = 1,
		["certificateChain"] = 1,
		["drmServerID"] = 1,
		["selectedAlgorithm"] = 1,
		["deviceID"] = 1,
		["nonce"] = 1
 	};
	res.version = node.version;
	res.type    = "licenseResponse";
	res.status  = ngx.ctx.status  ;
	res.protectedLicenses = license;
	res.responseTime      = ngx.time().. "";
	res.certificateChain  = _M.certificateChain;
	res.drmServerID		  = _M.g_server_id;
	res.selectedAlgorithm = _M.g_selectedAlgorithm;
	res.deviceID          = node.deviceID;
	res.nonce             = node.nonce;
	
	--local test = '{"type":"licenseResponse","version":"2.0","status":"success","selectedAlgorithm":"KMSProfile1","responseTime":"1599188389","deviceID":"zdx/5YDHb5pIzqbNzxA1b1CmUbigqNoeaGl4yz8IN8g=","drmServerID":"/XHjg6n6nbVknQCOiQp4DbDDFCIAt1ZaTMPi59OQlvc=","nonce":"AAECAwQFBgcICQoLDA0ODxAR","protectedLicenses":[{"licenseID":"X1Gtpex1fm8=","license":"AAAADgJfUa2l7HV+bwtfUa2lAQEAQw5Sb3RhS2V5TGl2ZVNubQMQBPYUg58owlPhz/xhS2qQhBDgdKOLZVj4HpgM09AKTIgmECSqk6h4x7NbBEvnPhKEae8CAgAhAM3cf+WAx2+aSM6mzc8QNW9QplG4oKjaHmhpeMs/CDfIAwMAqBIAcQQazDChM1ioCBeMOL/fZXiI2KKpDlIArnvxRRh4RyrHYoI/d2nEZlDdP8zU9GtT5nFxrA/8DETy2n4mpYD20WEHZwYGNYabFiM4FM0ci7Yv/jX2JfupbZCF3YuqbvG4t0W8jIy0R8NyO1k+H2iXvMraIBCUUu4/DlPCeE7K1kIiDBHpAyDN3H/lgMdvmkjOps3PEDVvUKZRuKCo2h5oaXjLPwg3yAMEADciABA01cGjqwA4NozCTdb8De+aARAE9hSDnyjCU+HP/GFLapCEIBCUUu4/DlPCeE7K1kIiDBHpAwUANyIAEJlqzUJDe8rx/dBpq+XLIi0BEOB0o4tlWPgemAzT0ApMiCYgEJRS7j8OU8J4TsrWQiIMEekDBgA3IgAQnY/QLEH1uG8P42y/pOZD2AEQJKqTqHjHs1sES+c+EoRp7yAQlFLuPw5TwnhOytZCIgwR6QMHALgSAIEE7l0SeQqBM1nfFQqMbwJO2hoT/G7j+DNIGzONICBg+8Q173y6y+oHAptMxUz0Tl+ODWncrDUrTnaa0gcCn9WFhwBDTwvfbTXdO0aMVSLgxpu5UDN7LissKk9Jyg6eNHBIrw+o95rqkkKXYjlQZOfWaCgswwpoYhh5O3AnmZsebbQhEOx1fm6+0BQlSijmWhAHlJ4DIM3cf+WAx2+aSM6mzc8QNW9QplG4oKjaHmhpeMs/CDfIBAgAMQEQBPYUg58owlPhz/xhS2qQhAUBBF8XpMQCBHHvhUQEBAAAAJbgBF9RrIDhBF9RrkIECQAxARDgdKOLZVj4HpgM09AKTIgmBQEEXxekxAIEce+FRAQEAAAAluAEX1GsgOEEX1GuQgQKADEBECSqk6h4x7NbBEvnPhKEae8FAQRfF6TEAgRx74VEBAQAAACW4ARfUayA4QRfUa5C/wsANEMQ7HV+br7QFCVKKOZaEAeUngAgSHd90WGXWux6C03GrdIBdqSwlD/U034eEO9hwMNaOgo="}],"certificateChain":["MIIBwTCCAWegAwIBAgIEEciBXDAKBggqgRzPVQGDdTA0MQswCQYDVQQGDAJDTjENMAsGA1UECgwEQ0RUQTEWMBQGA1UEAwwNRFJNIFNlcnZlciBDQTAeFw0xOTA1MDUwNzAwMDBaFw0yNDA1MDYwNjU5NTlaMEUxCzAJBgNVBAYMAkNOMRQwEgYDVQQKDAtTdW1hIFZpc2lvbjEgMB4GA1UEAwwXQ0RSTS1QT0MtRFJNU0VSVkVSLVNVTUEwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAARazBO7QgpeM81WW2smbaAPiM0Ag6UhpL41IMaHgkMyH/L4spTaJtuCC7U9wIbcztH0ABCd4iPgXAXepW/cuVDTo1YwVDAOBgNVHQ8BAf8EBAMCB4AwFQYDVR0lAQH/BAswCQYHKoEchu8wBzArBgNVHSMEJDAigCCoXjDqV093IYgV+10OcAxe/hMvkFAT2JbGzeCG1j8ONzAKBggqgRzPVQGDdQNIADBFAiEAkuZ0QIgSY5vpuUVNB4ivlXQOnbTv+FmrBnbunhq/8awCIDSSetEBslOtsqXEsWzCr89+GI8Q1KsgH7vShrQ83GeK","MIIB1TCCAXqgAwIBAgIEPpdMHjAKBggqgRzPVQGDdTAuMQswCQYDVQQGDAJDTjENMAsGA1UECgwEQ0RUQTEQMA4GA1UEAwwHUm9vdCBDQTAgFw0xOTA1MDUwNzAwMDBaGA8yMDY5MDUwNjA2NTk1OVowNDELMAkGA1UEBgwCQ04xDTALBgNVBAoMBENEVEExFjAUBgNVBAMMDURSTSBTZXJ2ZXIgQ0EwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAATBrbIBDT0ZVzSujLTaN+M/6kNFJnBHf+ON4h4Td3ecuqDs3OsX8lzCe2ps3Q9GgkOlTdQvDn0EDc05/Nr93X9Io34wfDApBgNVHQ4EIgQgqF4w6ldPdyGIFftdDnAMXv4TL5BQE9iWxs3ghtY/DjcwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwKwYDVR0jBCQwIoAg/gShDd110f1FY3fkB+CnCG3gVNkdP8YZv8jbk5SCNNEwCgYIKoEcz1UBg3UDSQAwRgIhAMryOGAga/re2g90+UM9y/tyP4u/TmjP2i1M0BW5vrxiAiEAo/3pXEtWM1z1VbdeV39uGZDmdNSSmLiKhLvz1MvS0hE="]}'
	--local str_req = test ;-- cjson.encode(res) ;
	local str_req = cjson.encode(res) 
	str_req = igsub(str_req, "%\\%/", "%/");
	
	
	local n_str = isub(str_req,1,ilen(str_req)-1);
	local ocsp_res   = "";--_M.ocsp_get();
	local ocsp_state = false;
	
	if node.extensions ~= nil then
		 local infos = node.extensions.drmServerInfos;
		 if infos ~= nil then
			 for i, v in ipairs (infos) do
			 		if v.drmServerID == _M.g_server_id then
			 			ocsp_state = v.ocspState;
			 		end
			 end
		 end
	end	
	if ocsp_state ~= true then ---从模块获取
		-- ocsp_res = [[MIIDFgoBAKCCAw8wggMLBgkrBgEFBQcwAQEEggL8MIIC+DCBq6ADAgEBoiIEIPOW4/jInQt4Q+2u65kHUaSYV4L6SKPxINc9L32dZ2reGA8yMDIwMTAyNzA0MDcwOVowbzBtMFgwDAYIKoEcgUUBgxEFAAQgUqzdC4slHDMq8HdGMx15TlACo9AfDBI9RPUoLj4J0LoEIJMCaI45TBaMbNJbr6/w3oSt++P8z4zPavaWacoyHPr2AgQRyIFcggAYDzIwMjAxMDI3MDQwNzA5WjAMBggqgRzPVQGDdQUAA0gAMEUCIQCHxZr7dy1bTtidpMMnFmpxEFUzhCqnzN2RvY1pHiWlvAIgA63JB+/9c2VQqL3ouARvfhIsCmwmJsCz8e6Qb7130LagggHuMIIB6jCCAeYwggGMoAMCAQICBGmnNx0wCgYIKoEcz1UBg3UwNDELMAkGA1UEBgwCQ04xDTALBgNVBAoMBENEVEExFjAUBgNVBAMMDURSTSBTZXJ2ZXIgQ0EwHhcNMjAwNzMwMTYwMDAwWhcNMjAxMDMxMTU1OTU5WjArMQswCQYDVQQGDAJDTjENMAsGA1UECgwEQ0RUQTENMAsGA1UEAwwET0NTUDBZMBMGByqGSM49AgEGCCqBHM9VAYItA0IABAT+e7tx1LOAgazwZQM/QFBGYaZszs9SptwKIzNSWAz2kP/jQSU1Lmtk1B127OZjjLLYtlQuwe7vFpGT4l2FstijgZQwgZEwKQYDVR0OBCIEIPOW4/jInQt4Q+2u65kHUaSYV4L6SKPxINc9L32dZ2reMA4GA1UdDwEB/wQEAwIHgDAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCTAPBgkrBgEFBQcwAQUEAgUAMCsGA1UdIwQkMCKAIHCVPRGoDbM8NYQPuriI/jMfnNhPxuXq3m4KYkynOwZYMAoGCCqBHM9VAYN1A0gAMEUCIQDXMsPzOlFUnxFrfwVgU23RcG9vx7Xge8zW2fZ00nEBlQIgXVs8pSr6vRUf2GhOG2dai58qAHXRaFJnYpdUUPXzcHE=]];
		-- sign     = gconcat ({n_str , ",\"ocspResponse\":\"" , ocsp_res , "\",\"signature\":\"\"}"});
		--resp_str = gconcat ({n_str , ",\"ocspResponse\":\"" , ocsp_res , "\",\"signature\":\"" , csignature (sign) , "\"}"});
		sign     = gconcat ({n_str , ",\"signature\":\"\"}"});
		resp_str = gconcat ({n_str , ",\"signature\":\"" , csignature (sign) , "\"}"});
	else
		sign     = gconcat ({n_str , ",\"signature\":\"\"}"});
		resp_str = gconcat ({n_str , ",\"signature\":\"" , csignature (sign) , "\"}"});
	end
	ngx.log(ngx.ERR, "resp3=" .. resp_str);
	ngx.print(resp_str);
	ngx.exit(200);
end

return _M;

