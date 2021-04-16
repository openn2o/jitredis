local _M  = {
    ["version"] = "v1.0.0.1"
}

_M.response = function ()
    ngx.log(ngx.ERR, "......default_response_print");
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
	result[1]  = '{"type":"licenseResponse","version":"2.0","status":"';
	result[2]  = ngx.ctx.status
	result[3]  = '","selectedAlgorithm":"KMSProfile1","responseTime":"';
	result[4]  = ngx.time() ;
	result[5]  = '","deviceID":"'
	result[6]  = ngx.ctx.deviceID ;
	result[7]  = '","drmServerID":"';
	result[8]  = ngx.ctx.g_server_id;
	result[9]  =  '","nonce":"';
	result[10] = ngx.ctx.nonce;
	result[11] ='","protectedLicenses":[],"certificateChain":[],"signature":""}'
	local  result_str = table.concat (result)
	ngx.log(ngx.ERR, "default_response_print=>" .. result_str);
	ngx.say(result_str);
	ngx.exit(200);
end


return _M;