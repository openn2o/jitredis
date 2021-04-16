-----
---  授权服务 Service OTGC
---  去掉证书链和验签
---  增加扩展CekTime
---  author agent.zy
--   time 2021/02/20
-----


local cjson        = require("cjson");
local resp_default = require("suma_default_action");
local keygateway   = require("suma_keygateway_action");
local spec_check   = require("suma_spec_action");
local pssh_check   = require("suma_pssh_action");
local crl_check    = require("suma_crl_action");
local live_preload = require("suma_livepreload_action");
local aaa_check    = require("suma_aaa_action");
local oscp_action  = require("suma_ocsp_action");
local dyn_lib      = require("suma_basecom_action");
-- local black_list_m = require("suma_black_list");
-- local cert  = require("suma_cert_module");
local isub 	   = string.sub;
local ilen     = string.len;
local igsub    = string.gsub;
local gconcat  = table.concat;
local c_decode = cjson.decode;
local cache_ngx= ngx.shared.ngx_share_dict;


local _M = {
	["g_server_id"] 	 	= nil,
	["g_certificate_chain"] = nil,
	["g_selectedAlgorithm"] = nil
};

_M.get_content_id_from_req = keygateway.get_content_id_from_req;
_M.get_ecek_from_key_gate  = keygateway.handle;
_M.spec_invalidate 		   = spec_check.handle;
_M.default_response_print  = resp_default.response;
_M.verify_chain = dyn_lib.verify_chain;
_M.verify       = dyn_lib.verify;
_M.signature    = dyn_lib.signature;
_M.pack_license = dyn_lib.pack_license;
local csignature = _M.signature;

_M.handle = function ()

	if (string.find(ngx.var.request_uri , "/sumadrm" ) == nil) then
		ngx.exit(404);
	end

	if "POST" ~= ngx.req.get_method() then
		ngx.exit(404);
	end

	ngx.ctx.status 	  = "success";
	
	if _M.g_server_id == nil then
		_M.g_server_id		      = cache_ngx:get ("GetKeyID0");
		_M.g_certificate_chain    = cjson.decode (cache_ngx:get("CertificateChain0"));
	end
	ngx.ctx.g_server_id 		  = _M.g_server_id;
	ngx.ctx.g_certificate_chain   = _M.g_certificate_chain;
	ngx.req.read_body();
	local body_str = ngx.req.get_body_data();
	if body_str == nil then
		if nil == body_str then
			if ngx.ctx.status == "success" then
				ngx.ctx.status = "malformedRequest";
			end
			_M.default_response_print();
			ngx.exit(200);
			return;
		end
	end
	ngx.log(ngx.ERR, "request body=" .. body_str);
	local node  = nil;
	pcall(function ()
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
	
	ngx.ctx.deviceID = node.deviceID;
	ngx.ctx.nonce    = node.nonce;

	---
	--- Spec ChinaDrm 协议检测
	--- 必要组件
	---
	_M.spec_invalidate (node);

	---兼容国际/国密算法
	if (ngx.ctx.g_selectedAlgorithm == "KMSProfile2") then
		ngx.ctx.g_server_id 		  = cache_ngx:get ("GetKeyID1");
		ngx.ctx.g_certificate_chain   = cjson.decode (cache_ngx:get("CertificateChain1"));
	end
	---
	--- ChinaDrm PSSH 标准扩展
	--- 必要组件
	---
	if pssh_check.allowInstall() then
		pssh_check.handle(node);
	end

	---
	--- Crl 证书列表
	--- 非必要组件
	---
	if crl_check.allowInstall() then
		crl_check.handle(node.deviceID);
	end
	------
	-- keygateway 请求
	-- 必要组件
	------
	local ecek = _M.get_ecek_from_key_gate(node);
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
	------
	-- AAA 鉴权
	-- 非必要组件
	------
	local aaa_result = nil;
	if aaa_check.allowInstall() then
		aaa_result = aaa_check.handle(node);
	end

	local packer = {
		["drmClientCertificate"] = "",
		["keyResponse"] = "",
		["deviceID"] = ""
	};
	
	packer.drmClientCertificate = node.certificateChain[1];
	packer.keyResponse          = ecek;
	packer.deviceID             = node.deviceID;
	if aaa_result ~= nil then
		packer.aaaResponse  = aaa_result;
	end
	local license = nil;

	if live_preload.allowInstall()  then
		license = live_preload.handle(node);
		if not license then
			license = _M.pack_license(node, packer);
		end
	else
		license = _M.pack_license(node, packer);
	end
	
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
	res.certificateChain  = ngx.ctx.g_certificate_chain;
	res.drmServerID		  = ngx.ctx.g_server_id;
	res.selectedAlgorithm = ngx.ctx.g_selectedAlgorithm ;
	res.deviceID          = node.deviceID;
	res.nonce             = node.nonce;
	
	local str_req = cjson.encode(res) 
	str_req       = igsub(str_req, "%\\%/", "%/");
	local n_str   = isub(str_req,1,ilen(str_req)-1);
	---
	--- ChinaDrm Ocsp
	--- 非必要组件
	---
	local ocsp_res = nil;
	if oscp_action.allowInstall() then
		ocsp_res = oscp_action.handle(node);
	end

	local sign    = nil;
	local resp_str= nil;
	if ocsp_res then ---从模块获取
		sign     = gconcat ({n_str, ",\"ocspResponse\":\"", ocsp_res, "\",\"signature\":\"\"}"});
		resp_str = gconcat ({n_str, ",\"ocspResponse\":\"", ocsp_res, "\",\"signature\":\"", csignature (sign), "\"}"});
	else
		sign     = gconcat ({n_str, ",\"signature\":\"\"}"});
		resp_str = gconcat ({n_str, ",\"signature\":\"", csignature (sign), "\"}"});
	end
	ngx.log(ngx.ERR, "resp3=" .. resp_str);
	ngx.print(resp_str);
	if ngx.ctx.inlineModuleExit then
		return ;
	end
	ngx.exit(200);
end
return _M;