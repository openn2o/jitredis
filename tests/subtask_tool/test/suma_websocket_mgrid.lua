if not ngx then
	ngx = {}
end

local server     = require "resty.websocket.server"
local cjson      = require "cjson"
local ws_command = require("suma_websocket_command");
local cache_ngx = ngx.shared.ngx_share_dict;

local get_to_cache   = function (key)
    return cache_ngx:get(key)
end

local wb, err = server:new{
    timeout = 5000,  -- in milliseconds
    max_payload_len = 65535,
}
if not wb then
    ngx.log(ngx.ERR, "failed to new websocket: ", err)
    return ngx.exit(444)
end

local data, typ, err = wb:recv_frame()

if err then
    ngx.log(ngx.ERR,  " err : " .. err)
end


if not data then
    if not string.find(err, "timeout", 1, true) then
        ngx.log(ngx.ERR, "failed to receive a frame: ", err)
        return ngx.exit(444)
    end
end

if typ == "close" then
    -- for typ "close", err contains the status code
    local code = err

    -- send a close frame back:

    local bytes, err = wb:send_close(1000, "enough, enough!")
    if not bytes then
        ngx.log(ngx.ERR, "failed to send the close frame: ", err)
        return
    end
    ngx.log(ngx.INFO, "closing with status code ", code, " and message ", data)
    return
end

if typ == "ping" then
    -- send a pong frame back:

    local bytes, err = wb:send_pong(data)
    if not bytes then
        ngx.log(ngx.ERR, "failed to send frame: ", err)
        return
    end
elseif typ == "pong" then
    -- just discard the incoming pong frame
else
    ngx.log(ngx.INFO, "received a frame of type ", typ, " and payload ", data)
end

wb:set_timeout(1000)  -- change the network timeout to 1 second

local result = {}
local respc ;
local zcmd  ;
local mcmd  ; 
if nil ~= data then
    local status , cmd = pcall(cjson.decode, data)
    if status then
        mcmd = cmd.sub_command;
        zcmd = cmd.sub_command .. "_0";
        if zcmd ~= nil then
            -- command module run.
            if cmd.data == nil then
                cmd.data = {}
            end
            if nil ~= cmd.data then
                if ws_command[zcmd] then
                    status ,respc = pcall(ws_command[zcmd] , wb, cmd.data);
                    if not status then
                        wb:send_text(tostring(respc));
                        return;
                    end
                end
            else
                -- command not implements
            end
        else
            --- command params error.
        end
    else
        -- command syntax err.
    end
end

if respc ~= nil then
    result.data   = respc;
end
result.ip     = get_to_cache("apollo_local_ip")
result.vip    = get_to_cache("apollo_local_vip")
result.time   = ngx.now() * 1000;
result.sub_command = mcmd;
local cmd_res = cjson.encode(result)

bytes, err = wb:send_text(cmd_res)

if not bytes then
    ngx.log(ngx.ERR, "failed to send a text frame: ", err)
    return ngx.exit(444)
end

local bytes, err = wb:send_close(1000, "")
if not bytes then
    ngx.log(ngx.ERR, "failed to send the close frame: ", err)
    return
end