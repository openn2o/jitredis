if not ngx then
	ngx = {}
end
--- web socket 版本 API
local server = require "resty.websocket.server"
local cjson  = require "cjson"
local ws_command = require("suma_websocket_command");
--create connection
local wb, err = server:new{
    timeout = 60000,
    max_payload_len = 65535
}


local trace = function (str)
    ngx.log(ngx.ERR, str);
end

if not wb then
    ngx.log(ngx.ERR, "failed to new websocket: ", err)
    return ngx.exit(444)
end

while true do
    local data, typ, err = wb:recv_frame()
    if wb.fatal then
        ngx.log(ngx.ERR, "failed to receive frame: ", err)
        return ngx.exit(444)
    end

    if not data then
        local bytes, err = wb:send_ping()
        if not bytes then
          return ngx.exit(444)
        end
    elseif typ == "close" then
        ngx.log(ngx.ERR, "close the websocket.");
        break
    elseif typ == "ping" then
        local bytes, err = wb:send_pong()
        wb:settimeout(10000);
        if not bytes then
            return ngx.exit(444)
        end
    elseif typ == "text" then
            if nil ~= data and data ~= "ping" then
                ngx.log(ngx.ERR, "data=" .. data);
                local status ,cmd = pcall(cjson.decode, data)
                if status then
                    if cmd.command ~= nil then
                        -- command module run.
                        if cmd.data == nil then
                            cmd.data = {}
                        end
                        if nil ~= cmd.data then
                            if ws_command[cmd.command] then
                                local status,  data = pcall( ws_command[cmd.command] , wb, cmd.data);
                                if not status then
                                    wb:send_text(tostring(data));
                                end
                            else
                                ws_command.ws_suma_command_notimplement_err(wb);
                            end
                        else
                            ws_command.ws_suma_command_notimplement_err(wb);
                        end
                    else
                        ws_command.ws_suma_command_params_err(wb);
                    end
                else
                    ws_command.ws_suma_command_syntax_err(wb);
                end
            end
    end
end