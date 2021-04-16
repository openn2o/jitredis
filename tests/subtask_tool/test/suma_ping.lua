----ping pong 加密卡服务检测

local _M = {}

_M.ping = function () 
	local sock = ngx.socket.tcp()
	sock:settimeout(1000) -- one second timeout
	local ok, err = sock:connect("10.254.12.13", 22)
	if not ok then
		-- ngx.say("enc card failed to connect: ", err);
		local cache_ngx = ngx.shared.ngx_share_dict;
		cache_ngx:set("abort:: enc", 1);
		return
	end
	local req_data = "ping"
	local bytes, err = sock:send(req_data)
	if err then
		ngx.log(ngx.ERR, "failed to send: ", err)
		return
	end
	local data, err, partial = sock:receive()
	if err then
		ngx.log(ngx.ERR , "failed to receive: ", err)
		return
	end
	sock:close()
	-- ngx.log(ngx.ERR, "response is: ", data)
end
return _M