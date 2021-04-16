local _M = {};
local temlate = require("suma_apollo_template");
_M.index = function ()
    local params =  ngx.req.get_uri_args();
    local server  = require "suma_apollo_server";
    ngx.header["Content-Type"] = "text/html";
    local data = '';
    if params.buiness_id == nil then
        return ngx.exit(403);
    end

    if params.token == nil  then
        return ngx.exit(404);
    end
    
    ngx.ctx.token      = params.token;
    ngx.ctx.buiness_id = params.buiness_id;

    local cdata = server.suma_project_get(params.buiness_id);

    if cdata == nil then
        cdata = "";
    end
    local client_script1 = [[res_flush(]] ..  cdata .. [[);]];
    local inline_scripts = {
        client_script1
    }

    if temlate.suma_res ~= nil then
        data = temlate.suma_res({
            inline_scripts = inline_scripts,
            token  =  params.token
        });
        ngx.say(data);
    end
end


local suma_echo = require("suma_echo");
_M.login = suma_echo.nologin;
return _M;