if not ngx then
	ngx = {}
end

local headers = ngx.req.get_uri_args();

if headers.ahuanxingqiu ~= nil then
	ngx.log(ngx.ERR, "[ahuanxingqiu]" .. headers.ahuanxingqiu);
	ngx.exit(200);
	return;
end
ngx.header["Content-Type"] = "text/plain;charset=utf-8"
local proxy= require("suma_upstream_client");
proxy.upstream_proxy();
