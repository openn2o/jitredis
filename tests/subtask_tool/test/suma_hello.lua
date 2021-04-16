

local cjson = require("cjson");
local http  = require("resty.http"); 

local  m_kgwURL = "http://127.0.0.1:8095/hello";
local  m_kgwStatus = 0;

local params = {  
   ssl_verify = false,
   method     = "POST"
}


-- local vip_client = require("suma_vip_client");
-- ngx.log(ngx.ERR, "cjson=" .. cjson.encode(vip_client.raw_get_live_vip_infos()))


local suma_sub_task   = require("suma_sub_task");
suma_sub_task.proxy_subtask_pass();



-- params.headers = {};
-- params.headers ["Content-Type"]  = "application/json";
-- params.body    = "{\"type\":\"DRMServerHello\"}";
-- local auth_url   = m_kgwURL;
-- local httpd   	 = http.new() ;
-- local rres, rerr = httpd:request_uri(auth_url, params) ;

-- if nil ~= rres then
-- 	if rres.code ~= 200 then
-- 		m_kgwStatus = -1;
-- 	end
-- 	-- ngx.log(ngx.ERR, m_kgwStatus);
-- end

-- local hello = {}
-- hello.kgwURL = "http://127.0.0.1:8095/hello";
-- hello.kgwStatus = m_kgwStatus;

-- ngx.say(cjson.encode(hello));