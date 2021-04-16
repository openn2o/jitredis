--------------------------------
-- 程序入口
-- agent.zy@aliyun.com
--------------------------------

if not ngx then
	ngx = {}
end

local worker_id  = ngx.worker.id();

if worker_id == 0 then --start of worker
		local delay_time         = 1;
		local diamond_delay_time = 2;


		------------apollo core --------------------------
		local server 		  = require("suma_apollo_server");
		local suma_config     = require("suma_ri_config");
		if  os.getenv("APOLLO_BUINESS_ID") ~= nil then
			server.buiness_id= os.getenv("APOLLO_BUINESS_ID");

			if server.buiness_id == nil then
				server.buiness_id = "Suma";
			end
		end
		if  os.getenv("APOLLO_OWNER_ID") ~= nil then
			server.owner_id = os.getenv ("APOLLO_OWNER_ID");
			if server.owner_id == nil then
				server.owner_id = "Drm";
			end
		end

		if  suma_config ~= nil then
			if nil ~=  suma_config.owner_id then
				server.owner_id  = suma_config.owner_id;
			end

			if nil ~=  suma_config.biz_id then
				server.buiness_id  = suma_config.biz_id;
			end
			ngx.log(ngx.ERR, "[!] config module is run.");
			local suma_sub_task   = require("suma_sub_task");
			if suma_sub_task ~= nil then
				ngx.log(ngx.ERR, "[!] sub task module is run.");
				suma_sub_task.init();
			end
		end
	

		ngx.log(ngx.ERR, "\n\n\n==========suma apollo v1.0 =============="   .. server.owner_id);
		local suma_config = require("suma_ri_config");
		local redis_host  = suma_config["cluster_data_center_ip"];
		local cache_ngx = ngx.shared.ngx_share_dict;
		cache_ngx:set("cluster_data_center_ip", redis_host);
		------------apollo diamond--------------------------
		local diamond 		= require("suma_diamond_client");
		------------apollo native client --------------------------
		local native_client = require("suma_native_client");
		------------apollo vipserver --------------------------
		local vip_client    = require("suma_vip_client");
		----------------------- native client init -----------------
		local ok, err = ngx.timer.at(1, native_client.native_client_init);
		----------------------- vipserver client init -----------------
		-- local ok, err = ngx.timer.at(1.5, vip_client.vipserver_init);
		----------------------- leader select   -----------------
		local ok, err = ngx.timer.every(delay_time, server.try_keep_alive);
		----------------------- diamond server init -----------------
		-- local ok, err = ngx.timer.at(diamond_delay_time, diamond.diamond_config_init);

		local uuid = require 'jit-uuid'

		if uuid ~= nil then
			uuid.seed() ;
		end
end -- end of worker

