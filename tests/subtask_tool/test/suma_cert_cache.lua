local _M = {}
if not ngx then
	ngx = {}
end

_M.set = function ()
	ngx.log(ngx.ERR, "suma_set_cert_to_cache");
	local cert = require("suma_cert_module");
	local data = cert.get_cert_data();

	if data ~= nil then
		ngx.log(ngx.ERR , data);
	end
	ngx.say("hello")
end


return _M;