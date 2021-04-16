
_M = {}

_M.handle = function (node)
	if not node.deviceID then
		ngx.ctx.status = "abort";
		_M.default_response_print();
		ngx.exit(200);
	end
	
	if (not node.nonce) or (node.nonce == "") then
		ngx.ctx.status = "abort";
		_M.default_response_print();
		ngx.exit(200);
	end
	
	if (not node.version) or (node.version ~= "2.0") then
		if ngx.ctx.status == "success" then
			ngx.ctx.status = "versionNotSupported";
		end
		_M.default_response_print();
		ngx.exit(200);
	end
	
	if (not node.type) or (node.type ~= "licenseRequest") then
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
	
	if (not node.supportedAlgorithms)  or (node.supportedAlgorithms[1] ~= "KMSProfile1") then
		if node.supportedAlgorithms[1] == "KMSProfile2" then
			ngx.ctx.g_selectedAlgorithm = "KMSProfile2";
		else
			ngx.ctx.status = "abort";
			_M.default_response_print();
			ngx.exit(200);
		end
	else
		ngx.ctx.g_selectedAlgorithm = node.supportedAlgorithms[1];
	end

	if (not node.certificateChain ) or (#node.certificateChain < 2) then
		ngx.ctx.status = "invalidCertificateChain";
		_M.default_response_print();
		ngx.exit(200);
	end
end


return _M;