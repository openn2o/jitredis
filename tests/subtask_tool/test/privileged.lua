
local process = require "ngx.process"
local ok, err = process.enable_privileged_agent()


if not ok then
	ngx.log(ngx.ERR, "enables privileged agent failed error:", err) 
end

local function reload()
	local cache_ngx 	= ngx.shared.ngx_share_dict;
	local command = cache_ngx:rpop("privileged_cmd");
	if command ~= nil then
		os.execute(command);
		ngx.log(ngx.ERR, "run command " .. command);
	end
end

if process.type() == "privileged agent" then
	local ok, err = ngx.timer.every(3, reload)
	if not ok then
		ngx.log(ngx.ERR, err)
	end
end
