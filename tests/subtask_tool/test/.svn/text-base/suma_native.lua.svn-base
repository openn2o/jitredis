if not ngx then
	ngx = {}
end

local cjson   = require "cjson"
local _M = {}
local  local_ip_file_read = function ()
	local f = io.open("/home/admin/local_ip", "r")
	if f == nil then
		return nil;
	end
	local d = f:read("*all")
	f:close();
	return d;
end

_M.local_ip = function ()
	local lc_ip = local_ip_file_read()
    lc_ip = string.gsub(lc_ip, "\n", "");
	ngx.say(lc_ip);
end

_M.reload_vip_hosts = function ()
	io.popen("awk -f /home/admin/bin/suma_vip_trim.awk /etc/hosts");
	ngx.exit(200)
end

_M.get_native_mem  = function ()
	-- local f = io.open("/home/admin/local_mem", "r")
	-- if f == nil then
	-- 	return nil;
	-- end
	-- local d = f:read("*all")
	-- f:close();
	-- ngx.say(d);
	ngx.say(200);
end

return _M;