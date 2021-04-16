function get_file(str)
	local f = io.open(str, "rb")
	if f == nil then
		ngx.log(ngx.ERR, "suma_cert_file_read failed");
		return nil;
	end
	local d = f:read("*all")
	f:close();
	return d;
end


ngx.req.read_body()

local bodydata = ngx.req.get_body_data()



if bodydata == nil then
	local file_name = ngx.req.get_body_file()
	if file_name then
		bodydata = get_file(file_name)
	end
	
	if nil == bodydata then
		ngx.exit(ngx.HTTP_BAD_REQUEST);
		return;
	end
end


ngx.log(ngx.ERR, ngx.encode_base64(bodydata));

ngx.say("ok");