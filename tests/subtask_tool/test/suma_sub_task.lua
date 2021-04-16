
---  v 1.1 RDA 实时计算支持
---  +增加告警和行为分析记录
---  +增加上报告警数据
---  v 1.2 CCM1 通用计算支持
---  V 1.2 增加unix tcp监控

local _M  = {}
local cjson = require("cjson")
local http  = require("http"); 
local apollo= require("suma_apollo_server");
local cache_ngx 	= ngx.shared.ngx_share_dict;
local worker_id     = ngx.worker.id();
local _m_uri_args   = ngx.req.get_uri_args
local rnd = math.random;
_M.VERSION="1.1"
_M.tasks  = {}
_M.local_caches = {}
_M.max_try = 3;
_M.init_redis = false;
_M.build_sub_task_key_master = function (v)
	return  v.owner_id .. v.biz_id ..  "master";
end

_M.build_sub_task_key_search = function (v)
	return  v.owner_id .. v.biz_id ..  "*.vip";
end

_M.build_sub_task_local_vip = function (v, key)
	local gen_key = ngx.encode_base64(key)
	gen_key = string.gsub(gen_key, "=", "");
	gen_key = string.gsub(gen_key, "=", "");
	return  v.owner_id ..  v.biz_id ..".".. gen_key .. ".vip";
end

_M.redis_cluster_change = function ()
	local suma_config = require("suma_ri_config");
	local redis       = require("suma_apollo_redis");
	local redis_host  = suma_config["cluster_data_center_ip"];
	local red     = redis:new();
	local ok, err = red:connect(redis_host, 26379);
	if err then
		suma_config["cluster_data_center_ip"] = redis_host;
		apollo.redis_host = redis_host;
		cache_ngx:set("cluster_data_center_ip", redis_host);
		ngx.log(ngx.ERR, ERROR_REDIS_ERR , err)
		return red:close();
	end


	local resp, err = red:call_command(
		"info", "Sentinel"
	)
	if  err ~= nil then
		red:close();
		ngx.log(ngx.ERR, "err=" .. err);
		return;
	end
	local start = (string.find(resp, "address=")) + 8;
	local end_d = (string.find(resp, "slaves"))   - 7;
	if start and  end_d then
		local host = string.sub(resp, start, end_d);
		if host == redis_host then
			red:close();
			return;
		end
		suma_config["cluster_data_center_ip"] = host;
		apollo.redis_host = host;
		cache_ngx:set("cluster_data_center_ip", host);
		ngx.log(ngx.ERR, "change redis master is change" .. apollo.redis_host);
	end
	red:close();
end

----包装外部服务为集群可感知科里化服务
_M.gen_handler = function (loc1)
	if loc1 == nil then
		ngx.log(ngx.ERR, "params is null");
		return;
	end

	local params = {
	   method     = "GET",
	   ssl_verify = false ,
	   body       = ""
	}
	params.headers = {};
	
	---unix tcp / http schema 
	local schema = loc1.keep_alive_uri:sub(1, 4);

	local rerr ;
	local rres ;
	if schema == "uinx" then
		local sock    = ngx.socket.tcp();
		ngx.log(ngx.ERR,loc1.keep_alive_uri:sub(8))
		sock:settimeout(200)
		local ok, err = sock:connect(loc1.keep_alive_uri:sub(8), loc1.port);
		
		if err ~= nil then
			rres = nil;
			rerr = err;
			ngx.log(ngx.ERR, 
			"tcp check failed." .. err,",port=" .. loc1.port);
		else
			rres = 1;
			rerr = nil;
		end
		sock:close();
	else
		local httpd   	 = http.new() ;
		httpd:set_timeout(200) ;
		rres, rerr = httpd:request_uri(loc1.keep_alive_uri, params) ;
	end
	local live_key   = _M.build_ip_port_auth_key  (loc1);
	if rerr ~= nil then
		rres = nil;
	end
	-- ngx.log(ngx.ERR, "ngx="  .. tostring(rres) .. "," .. tostring(rerr));
	if rres ~= nil and (rerr == nil) then
			if cache_ngx:incr(live_key .. "ok", 1, 0) > 1 then
				loc1.key       = _M.build_sub_task_key_master(loc1);
				loc1.search    = _M.build_sub_task_key_search(loc1);
				loc1.local_vip = _M.build_sub_task_local_vip(loc1,
								 cache_ngx:get ("apollo_local_ip2"));
				loc1.raw       = cache_ngx:get ("apollo_local_ip2");
				local status = apollo.suma_subtask_keep_live (loc1);
				if tonumber(cache_ngx:get ("redis_down")) == 2 then
					if status then
						ngx.timer.at (
							3,
							_M.sub_tasks_register
						);
						cache_ngx:set ("redis_down", 0);
					end
				end
				if not status then
					cache_ngx:set ("redis_down", 2);
					_M.redis_cluster_change ();
					return;
				end
				cache_ngx:set ("redis_down", 0);
				cache_ngx:set (live_key, 1, 1);
			end
	else
		cache_ngx:set(live_key .. "ok", 0);
		if loc1.watch_dog then
			-- ngx.log(ngx.ERR, "watch_ttl" .. live_key .. ":" .. tostring(cache_ngx:get(live_key .. ".watch_ttl")));
			if((nil == cache_ngx:get(live_key .. ".watch_ttl"))) then
				if  loc1.kill_cmd then
					cache_ngx:lpush ("privileged_cmd", loc1.kill_cmd);
				end
				if  loc1.restart_cmd then
					cache_ngx:lpush ("privileged_cmd", loc1.restart_cmd);
					cache_ngx:set(live_key .. ".watch_ttl", 1, 30);
				end
			end
		end
	end

	if  cache_ngx:get("updateLimit" .. loc1.biz_id) == nil then
		if _M.init_redis ~= true then
			_M.init_redis = apollo.try_redis_connect();
			_M.sub_tasks_register();
			ngx.log(ngx.ERR, "try to connect redis.");
		end

		_M.update_subtask_cluster_infos(loc1) ;
		if cache_ngx:get("checkRedisLimit") == nil then
			cache_ngx:set("checkRediisLimit", 1,2);
		end
		cache_ngx:set("updateLimit" .. loc1.biz_id, 1, 3);
	end
end

----获取子任务集群活跃的信息
_M.update_subtask_cluster_infos = function (v)
	local keys = v.owner_id.. v.biz_id .. ".cluster";
	local lock_m = cache_ngx:get(keys .. "lock");
	if not lock_m then
		-- ngx.log(ngx.ERR, "_M.update_subtask_cluster_infos update. ");
		local livekeys = apollo.suma_subtask_vip_list (v);
		if tonumber(livekeys) == 1 then
			return;
		end
		-- ngx.log(ngx.ERR, "sub livekeys=" .. cjson.encode(livekeys));
		if not livekeys then
			ngx.log(ngx.ERR, "not find any cluster online");
			return nil;
		end
		local cache_data = cache_ngx:get(keys .. ".cache");
		local infos      = nil;
		if cache_data ~= nil then
			infos = cjson.decode(cache_data);
		else
			infos = apollo.suma_subtask_vip_server_list(v);
			if tonumber(infos) == 1 then
				return;
			end
			if not infos then
				return;
			end
			if #infos >= 1 then
				cache_ngx:set(keys .. ".cache", cjson.encode(infos), 3600);
			end
		end
		-- ngx.log(ngx.ERR, "infos=" .. cjson.encode(infos));
		if not infos then
			ngx.log(ngx.ERR, "not find any cluster info");
			return nil;
		end
		local hash_s = {}
		for i, val in ipairs(infos) do
			local tmp =  cjson.decode (val);
			hash_s [tmp.local_vip] = tmp;
		end
		local loc_ip =  cache_ngx:get ("apollo_local_ip2") ;
		local live_infos = {}
		if 'number' == type(livekeys) then
			livekeys = {};
		end
		for i, val in ipairs(livekeys) do
			if hash_s [val] ~= nil then
				if loc_ip ~= hash_s [val].raw then
					live_infos [#live_infos + 1] = hash_s [val];
				else
					-- ip eq and 
					if (8091 ~= hash_s [val].port)  then
						live_infos [#live_infos + 1] = hash_s [val];
					else
						if (10081 ~= hash_s [val].port)  then
							live_infos [#live_infos + 1] = hash_s [val];
						end
					end
				end
			end
		end
		if #live_infos < 1 then
			return;
		end
		cache_ngx:set(keys, cjson.encode(live_infos));
		cache_ngx:set(keys .. "lock", 1 , 1);
	end
end

---req 转化为在线存活服务的vo
_M.live_biz_infos = function(bizId)
	local locker = apollo.owner_id .. bizId .. worker_id ..  ".lock";
	local exists = cache_ngx:get (locker);
	
	if nil ~= exists then
		local cache_data = _M.local_caches[apollo.owner_id .. bizId];
		if cache_data ~= nil then
			return cache_data;
		end
	end
	
	local loc1 = {}
	loc1.owner_id  = apollo.owner_id ;
	loc1.biz_id    = bizId;
	local vips = cache_ngx:get ( loc1.owner_id .. loc1.biz_id .. ".cluster" ) ; 
	 if nil  == vips then
		ngx.log(ngx.ERR, "not find the service for subtask");
		_M.update_subtask_cluster_infos(loc1)
		return {};
	 end
	 local ndata = cjson.decode (vips);
	_M.local_caches[apollo.owner_id .. bizId] = ndata;
	cache_ngx:set (locker, 1, 1);
	return ndata;
end

_M.ping = function (ip, port) 
	local sock    = ngx.socket.tcp()
	sock:settimeout(100)
	local ok, err = sock:connect(ip, port)
	if err then
		ngx.log(ngx.ERR, "response1 is: ",
		 "err=" .. err .. "\nport" .. port .. "\nip" .. ip);
		sock:close()
		return false
	end
	sock:close()
	return true;
end

_M.build_ip_port_limit_key = function (v)
	if v.raw and v.port then
		return v.raw .. v.port .. "limit";
	end
	return "error:"
end

_M.build_ip_port_auth_key = function (v)
	if v.raw and v.port then
		return v.raw .. v.port .. "live";
	end
	return "error:"
end

_M.trim_dead_line_service = function (arr) 
	local data = {}
	for i,v in ipairs (arr) do
		local live_key = _M.build_ip_port_auth_key(v);
		local ticket   = cache_ngx:get (live_key);
		if tostring(ticket) ~= 2 then ---说明下线
			data[#data+1] = v;
		end
	end
	return data;
end

local nsleep = ngx.sleep;

-- local _biz      = require("suma_biz_inter");
local apollo_bi = "cluster_data_center_ip" --- 需要更换

_M.co_handle = function (limit, live_key, vos, idx, trace_id, pass_loop_forward)
	local vo = nil;
	local _max_try = _M.max_try;
	local isPass = 0;
	local asint  = tonumber;
	
	if trace_id == nil then
		trace_id = "";
	end
	
	if pass_loop_forward == nil then
		pass_loop_forward = "";
	end
	isPass = asint (cache_ngx:get(live_key));
	
	if isPass == 0 then
		while limit < _max_try do
			isPass = asint (cache_ngx:get(live_key));
			if isPass ~= 0 then
				break;
			end
			local timeout = 0.001 + (rnd(20000) / 1000000);
			limit = limit + 1;
			nsleep (timeout);
		end
	end
	
	if isPass ~= 1 then
		local old = idx;
		idx = 1;
	
		if idx == old then
			if vos[idx+1] ~= nil then
				idx = idx + 1;
			else
				if vos[idx-1] ~= nil then
					idx = idx - 1;
				end
			end
		end
	end
	vo  = vos[idx];
	if  vo == nil then
		ngx.exit(500);
		return;
	end
	local httpc   = http.new();
	local ok, err = httpc:connect(vo.raw , vo.port);
	if not ok then
		ngx.exit(500);
		httpc:close();
		return;
	end
	httpc:set_timeout(4500);
	httpc:proxy_response(httpc:proxy_request(10081,  {} , trace_id, pass_loop_forward));
	httpc:close();
	if _biz ~= nil then
		if cache_ngx:get (apollo_bi) ~= nil then
			_biz.tracking_end (vo);
		end
	end
end
local system_type = require("suma_system_type");
---内部代理
_M.proxy_subtask_pass = function() 
	local vos    = nil;
	if ngx.ctx.biz_id ~= nil then
		vos = _M.live_biz_infos (ngx.ctx.biz_id);
	else
		local params = _m_uri_args();
		if params["biz_id"] ~= nil then
			vos = _M.live_biz_infos (params["biz_id"]);
		end
	end
	
	if not vos then
		ngx.exit(500);
		return;
	end
	
	local size_t = #vos
	if  size_t < 1 then
		ngx.exit(500);
		return;
	end
	
	local idx = rnd(size_t);
	local vo  = vos[idx];
	if vo == nil then
		ngx.exit(500);
		return;
	end
	
	local loc_ip =  cache_ngx:get ("apollo_local_ip2") ;
	
	if ngx.ctx.pass_loop_forward == nil then
		local headers = ngx.req.get_headers()
		if headers ['pass_loop_forward'] ~= nil then
			ngx.ctx.pass_loop_forward = headers ["pass_loop_forward"] ;
		else
			ngx.ctx.pass_loop_forward = loc_ip;
		end
	end
	
	if ngx.ctx.pass_loop_forward == vo.raw and 
		(system_type.type == "loadavg") then
		if vos[idx+1] ~= nil then
			idx = idx + 1;
		else
			if vos[idx-1] ~= nil then
				idx = idx - 1;
			end
		end
		vo = vos[idx];
	end
	
	if _biz ~= nil then
		if cache_ngx:get (apollo_bi) ~= nil then
			_biz.tracking_begin (vo); --开始数据打点
		end
	end
	
	local limit_key  =  _M.build_ip_port_limit_key (vo);
	local live_key   =  _M.build_ip_port_auth_key  (vo);
	
	if vo.raw ~= loc_ip then
		if (cache_ngx:incr(limit_key, 1, 0, 1) == 1) then
			local status = _M.ping (vo.raw, vo.port);
			if status then
				cache_ngx:set (live_key, 1, 1);
			else
				cache_ngx:set (live_key, 2, 1);
			end
		end
	end
	
	if vo.raw == loc_ip then
		if vo.port == "8091" then
			ngx.ctx.inlineModuleExit = true;
			require("suma_main").handle();
			if cache_ngx:get (apollo_bi) ~= nil then
				if _biz ~= nil then
					_biz.tracking_end (vo);
				end
			end
			ngx.exit(200);
			return;
		end
	end
	
	if ngx.ctx.trace_id == nil then
		ngx.ctx.trace_id = "";
	end
	
	if ngx.ctx.pass_loop_forward == nil then
		ngx.ctx.pass_loop_forward = "";
	end
	
	local listener = coroutine.create(_M.co_handle);
	local _trace_id= ngx.ctx.trace_id;
	coroutine.resume(listener, 0, live_key, vos, idx, _trace_id, ngx.ctx.pass_loop_forward); --trace_id
end

----注册子任务
_M.init = function ()
	ngx.log(ngx.ERR, "sub task init ...")
	local suma_config  = require("suma_ri_config");
	ngx.log(ngx.ERR, "suma_ri_config =  " .. #suma_config['biz_task'] );
	local task_n = #suma_config['biz_task'];
	local task_t =  suma_config['biz_task'];
	if task_n > 0 then
		local step = 1;
		while step <=  task_n do
			local v = task_t[step];
			if v == nil then
				break;
			end
			 ngx.log(ngx.ERR, "register extern service " .. v.biz_id);
			 if v.owner_id == nil then
				v.owner_id = apollo.owner_id;
			 end
			_M.tasks [v.biz_id] = {}
			_M.tasks [v.biz_id] .handle =  _M.gen_handler;
			_M.tasks [v.biz_id] .params  =  v;
			step = step + 1;
		end
	else
		ngx.log(ngx.ERR, "no sub task in biz_task list");
	end
	local worker_id  = ngx.worker.id();
	if worker_id == 0 then --start of worker
		_M.start();
	end
end

_M.init_tick = false;
---全部注册
_M.sub_tasks_register = function ()
	_M.redis_cluster_change ();

	for k, v in pairs(_M.tasks) do
		if v ~= nil then
			if (v.params ~= nil) and (v.handle ~= nil) then
				v.params.key       = _M.build_sub_task_key_master(v.params);
				v.params.search    = _M.build_sub_task_key_search(v.params);
				v.params.local_vip = _M.build_sub_task_local_vip(v.params,
									 cache_ngx:get ("apollo_local_ip2"));
				v.params.raw       = cache_ngx:get ("apollo_local_ip2");
				apollo.suma_subtask_register (v.params);
			end
		end
	end
	
	if _M.init_tick == false then
		ngx.log(ngx.ERR, "watch dog is run")
		_M.init_tick = true;
		--不能使用ipairs 遇到null截断的问题
		for k, v in pairs(_M.tasks) do
			if v ~= nil then
				if (v.params ~= nil) and (v.handle ~= nil) then
					ngx.timer.every(2,
					function ()
						v.handle(v.params);
					end
					);
				end
			end
		end
	end
end



----开启子任务
_M.start = function ()
	---启动注册
	ngx.timer.at (
		3,
		_M.sub_tasks_register
	)
end
return _M