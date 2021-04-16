
if not ngx then
	ngx = {};
	ngx.log = print;
end


local process = require "ngx.process"

local function reload()
	local cache_ngx 	= ngx.shared.ngx_share_dict;
	local command = cache_ngx:rpop("privileged_cmd");
	if command ~= nil then
		local t = os.execute (command)
		ngx.log(ngx.ERR, "ENV JAVA_HOME = " .. tostring(os.getenv("JAVA_HOME")));
		ngx.log(ngx.ERR, "run command " .. command);
	end
end

if process.type() == "privileged agent" then
	local ok, err = ngx.timer.every(3, reload)
	if not ok then
		ngx.log(ngx.ERR, err)
	end
	os.execute ("source /etc/profile.d/java.sh");
	reload(); --堆积的命令处理
end


local apollo       = require("suma_apollo_server");
local black_list_m = require("suma_black_list");

local cjson = require("cjson");
if black_list_m ~= nil then
	black_list_m.start();
end

local _M = {};
_M.version = "0.0.0.1";
local cache_ngx 	= ngx.shared.ngx_share_dict;

local worker_id  = ngx.worker.id();
if worker_id == 0 then
	local ok, err = ngx.timer.at(10, function ()
		ngx.log(ngx.ERR, "cert is wait for basecommponet cluster.");
		local dyn_lib = require("suma_dyn_lib");
		local ok, err = ngx.timer.every (3,
		function ()  
			dyn_lib.cert();
		end);
		if not ok then
			ngx.log(ngx.ERR, err)
		end
	end);

	

	local suma_config  = require("suma_ri_config");
	local task_n = table.getn(suma_config['biz_task']);
	ngx.log(ngx.ERR, "all cluster state reset now." .. task_n);
	local task_t =  suma_config['biz_task'];
	ngx.log(ngx.ERR, "config data=" .. cjson.encode(suma_config));
	local step = 1;
	while step <=  task_n do
		local v = task_t[step];
		ngx.log(ngx.ERR, "biz id =" .. tostring(v.biz_id));
		if v.owner_id == nil then
			v.owner_id = apollo.owner_id;
		end
		ngx.log(ngx.ERR, v.restart_cmd);
		if v.watch_dog then
			cache_ngx:lpush ("privileged_cmd", v.restart_cmd);
		end
		step = step + 1;
	end

	ngx.timer.at(
		5, function () 
			require("suma_apollo_client");
		end
	)
	
end
return _M;