--[[
数码分布式中间件 apollo 客户端库
--]]
local cjson 	 = require "cjson"
local redis      = require("suma_apollo_redis");
local http  	 = require("http");
local gsub 		 = string.gsub;
if not ngx then
	ngx = {}
end

local cache_ngx  = ngx.shared.ngx_share_dict;
local _M   	     = {}
local suma_config = require("suma_ri_config");

_M.redis_host = suma_config["cluster_data_center_ip"];
if not _M.redis_host then
	_M.redis_host = "127.0.0.1";
end

_M.redis_port = suma_config["cluster_data_center_port"];
if not _M.redis_port then
	_M.redis_port = 6379;
end

local redis_host  = _M.redis_host
local redis_port  = _M.redis_port

local c_dump = string.dump;
local ERROR_REDIS_ERR 			 ="connect to redis error : ";
local CONST_API_SUMA_KEEP_ALIVE  ="sumavlib.suma_keep_alive";
local CONST_API_SUMA_VIP_LIST    ="sumavlib.suma_vip_list";
local CONST_API_SUMA_TRY_LEADER  ="sumavlib.suma_try_leader";
local CONST_API_DIAMOND_PUBLISH  ="sumavlib.suma_diamond_publish";
local CONST_API_DIAMOND_LIST 	 ="sumavlib.suma_diamond_list";
local CONST_API_SUMA_VIP_REGISTER="sumavlib.suma_vip_register";    --本机vip注册
local CONST_API_SUMA_VIP_SERVER_LIST="sumavlib.suma_vip_server_list"; --获取vip注册列表
local CONST_API_SUMA_VIP_KILL    = "sumavlib.suma_vip_kill"
local CONST_API_SUMA_VIP_RESET   = "sumavlib.suma_vip_reset"

_M.cache     = {}
_M.localCmds = {}
_M.VERSION   = 0;
_M.is_leader = 0;
_M.local_vip = nil;
_M.raw_ip    = nil;
_M.master_vip= nil;
_M.master_key= nil;

_M.owner_id  = "Suma";
_M.buiness_id= "Drm";
_M.vip_list_cache_key = "vip_list_cache_key";
_M.block_time = 0;


local function close_redis(redis)
	return redis:close();
end


------------------------code hotload------------------------------------
_M.build_code_key = function ()
	local oid = _M.owner_id;
	local bid = _M.buiness_id;

	if ngx.ctx.token then
		oid = ngx.ctx.token;
	end

	if ngx.ctx.buiness_id then
		bid = ngx.ctx.buiness_id;
	end

	ngx.log(ngx.ERR, "code_key="   .. oid .. bid .. "code" );
	ngx.log(ngx.ERR, "redis_host=" .. _M.redis_host .. "code" );
	-- _M.redis_host = "10.254.12.19"
	return oid .. bid .. "code";
end

local build_hot_code_lock_key = function (t, id)
	if id then
		return 'code_lock_' .. t .. id;
	end
	return 'code_lock_' .. t .. ngx.worker.id();
end

_M.suma_code_list_data = function ()
	if 1 then
		return nil;
	end
	local mkey =  _M.build_code_key ();
	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err   = red  :connect(redis_host, redis_port);
	local data, err = red  :scan(0, "MATCH" , mkey .. "*.code_cache", "COUNT", 1000000);
	if err then
		ngx.log(ngx.ERR, "err=" .. err);
		close_redis(red);
		return;
	end
	close_redis(red);
	-- ngx.log(ngx.ERR, cjson.encode(data));
	if data[2] ~= nil then
		local result = {}
		local mkeyLen= #mkey;
		local find_s = string.find;
		local sub_s  = string.sub;
		for index, value in ipairs(data[2]) do
			local s1 =  sub_s(value , mkeyLen +1, find_s(value, ".code_cache") - 1);
			if s1 ~= nil then
				result[index] = s1;
			end
		end
		return result;
	end
	return nil ;
end

_M.suma_code_release_lock = function ()
	local mkey =  _M.build_code_key ();
	local key  = mkey .. ".lock";

	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err   = red  :connect(redis_host, redis_port);
	local data, err = red  :set(key, 0);
	if err then
		close_redis(red);
		return nil ;
	end
	close_redis(red);
	return nil ;
end

_M.try_redis_connect = function () 
	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err   = red:connect(redis_host, redis_port);
	red:close();
	if err then
		return false;
	end
	return true;
end
_M.suma_code_select_tracker_vip = function ()
	if 1 then
		return nil;
	end
	local mkey =  _M.build_code_key ();
	local key  = mkey .. ".lock";
	---是否存在镜像
	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err   = red  :connect(redis_host, redis_port);
	
	if err then
		close_redis(red);
		return nil ;
	end
	local data, err = red  :incr (key);
	if tonumber(data) == 1 then
		red:expire(key, 60);
		------------------------------------------
		local data, err = red:scan(0, "MATCH" , mkey .. "*.code_cache", "COUNT", 10000000);
		if err then
			ngx.log(ngx.ERR, "err=" .. err);
			close_redis(red);
			return;
		end
		if data[2] then
			local codes = data[2];
			local len   = #codes;
			red:init_pipeline();
			for i=1,len,1 do
				if codes[i] ~= nil then
					red:get(codes[i]);
				end
			end
			local results, err = red:commit_pipeline()
			if not results then
				close_redis(red);
				return
			end
			local cache_code = _M.set_to_cache;
			local mkeyLen    = #mkey;
			local find_s     = string.find;
			local sub_s      = string.sub;


			local keys_cache = {}
			for i=1,len,1 do
				if nil ~= results[i] then
					local s1 =  sub_s(codes[i] , mkeyLen +1, find_s(codes[i], ".code_cache") - 1);
					ngx.log(ngx.ERR, "code reset key=" .. s1  .. ", data=" .. results[i]);
					keys_cache[i] = s1;
					cache_code("$" .. s1, results[i]);
					local count = ngx.worker.count();
					for j=0, count, 1 do
						local lock_ckey = build_hot_code_lock_key(s1, j);
						cache_code(lock_ckey , 0);
					end
				end
			end

			---制作镜像索引
			local mkey2 = mkey .. ".code_list";
			local mkey3 = mkey .. ".code_num";
			local mkey4 = mkey .. "code_list.snapshot";
			red:set  (mkey4, cjson.encode(keys_cache));
			red:del  (mkey2);
			red:set  (mkey3, 0);
			red:lpush(mkey2, _M.get_to_cache("apollo_local_vip"));
			red:incr (mkey3);
			red:expire(mkey3, 60);
			close_redis(red);
		end
		------------------------------------------
	else
		---镜像有里获取
		local mkey3   = mkey .. ".code_num";
		local mkey4   = mkey .. "code_list.snapshot";

		local n , err = red:get(mkey3);

		if err then
			close_redis(red);
			return nil;
		end

		local nc = tonumber(n);
		local idx= math.random(nc) - 1;
		if idx < 0 then
			idx = 0;
		end
		local mkey2 = mkey .. ".code_list";
		local n , err2 = red:lindex(mkey2, idx);
		if err ~= nil then
			ngx.log(ngx.ERR, err2);
			close_redis(red);
			return nil;
		end

		local list , err = red:get(mkey4);
		if not list then
			close_redis(red);
			return;
		end
		local code_list_c =	cjson.decode(list)
		if code_list_c == nil then
			close_redis(red);
			return;
		end

		local call_vip = _M.call_vip_interface;
		for index, value in ipairs(code_list_c) do
			call_vip(n, "suma_echo" , "code" , function (body)
				if body ~= nil then
					local code_body = cjson.decode(body);
					local count     = ngx.worker.count();
					if code_body.code and code_body.data then
						local cache_code = _M.set_to_cache;
						cache_code("$" .. code_body.code, code_body.data);
						for j=0, count, 1 do
							local lock_ckey = build_hot_code_lock_key(code_body.code, j);
							cache_code(lock_ckey , 0);
						end
					end
				end
			end, "code=" .. value );
		end
	end

	local mkey3 = mkey .. ".code_num";
	red:incr (mkey3);
	close_redis(red);
	return nil;
end

_M.suma_insert_code_version  = function (version, keyword)
	local key	    = _M.build_code_key ()  .. ".version.list";
	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err   = red  :connect(redis_host, redis_port);
	ngx.log(ngx.ERR, "suma_insert_code_version=" .. key);
	if err then
		close_redis(red);
		return nil ;
	end

	local version_data = {}

	version_data.version = version;
	version_data.key_word= keyword;
	version_data.update_time= (ngx.now() * 1000)
	red:lpush(key, cjson.encode(version_data));
	red:close();
end

_M.suma_get_code_version = function ()
	local key	    = _M.build_code_key ()  .. ".version.list";
	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err   = red  :connect(redis_host, redis_port);
	if err then
		close_redis(red);
		return nil ;
	end
	--red:lpush(key, cjson.encode(version_data));
	local ok, err  = red:lrange(key, 0, 9);
	if err then
		close_redis(red);
		return nil ;
	end
	red:close();
	return ok;
end
_M.suma_publish_code_save2   = function (version)
	local version_key = _M.build_code_key () ;
	local list= _M.suma_code_list_data();

	if not list then
		ngx.log(ngx.ERR, "not find list");
		return;
	end

	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err   = red  :connect(redis_host, redis_port);
	-- local data, err = red  :incr (key);
	if err then
		close_redis(red);
		return nil ;
	end

	ngx.log(ngx.ERR, cjson.encode(list));
	local prefix = _M.build_code_key () ; --.. k .. ".code_cache";
	red:init_pipeline();

	for index, value in ipairs(list) do
		-- statements
		local loc_k = version_key .. value .. ".version." .. version ;
		ngx.log(ngx.ERR, "lock=" .. loc_k);
		red:get(loc_k);
	end

	local results, err = red:commit_pipeline()
	if not results then
		close_redis(red);
		return
	end
	close_redis(red);

	-- local red2       = redis:new();
	-- local ok, err    = red2  :connect(redis_host, redis_port);
	-- red2:init_pipeline();
	-- ngx.log(ngx.ERR, cjson.encode(results))
	for index, value in ipairs(results) do
		-- local loc_k = version_key .. list[index] .. ".version." .. version ;
		-- red2:set(loc_k , value);
		_M.suma_code_publish(list[index], value);
	end

	-- local results, err = red2:commit_pipeline();
	-- if not results then
	-- 	close_redis(red2);
	-- 	return
	-- end

	close_redis(red);
	-- close_redis(red2);
end

_M.suma_publish_code_save    = function (version)
	local key = _M.build_code_key () .. version .. ".version";
	local version_key = _M.build_code_key () ;
	local list= _M.suma_code_list_data();

	if not list then
		ngx.log(ngx.ERR, "not find list");
		return;
	end

	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err   = red  :connect(redis_host, redis_port);
	local data, err = red  :incr (key);
	if err then
		close_redis(red);
		return nil ;
	end

	-- ngx.log(ngx.ERR, cjson.encode(list));
	local prefix = _M.build_code_key () ; --.. k .. ".code_cache";
	red:init_pipeline();

	for index, value in ipairs(list) do
		-- statements
		local k = prefix .. value .. ".code_cache";
		red:get(k);
	end

	local results, err = red:commit_pipeline()
	if not results then
		close_redis(red);
		return
	end
	close_redis(red);

	local red2       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err    = red2  :connect(redis_host, redis_port);
	red2:init_pipeline();
	-- ngx.log(ngx.ERR, cjson.encode(results))
	for index, value in ipairs(results) do
		local loc_k = version_key .. list[index] .. ".version." .. version ;
		red2:set(loc_k , value);
		_M.suma_code_publish(list[index], value);
	end

	local results, err = red2:commit_pipeline();
	if not results then
		close_redis(red2);
		return
	end

	close_redis(red);
	close_redis(red2);
end

_M.suma_publish_code_version = function ()
	local key = _M.build_code_key () .. ".version";
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local ok, err = red:incr(key);
	close_redis(red);
	if ok then
		return ok;
	end

	return 0;
end


_M.all_cluster_info = function ()
	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local resp, err = red:call_command("sumavlib.suma_get_all_register_instance");
	close_redis(red);
	if err then
		return nil;
	end

	return resp;
end

_M.suma_get_all_cluster_names = function ()
	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip");
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local resp, err = red:call_command("sumavlib.suma_get_all_cluster_names");
	close_redis(red);
	if err then
		return nil;
	end
	return resp;
end

_M.all_live_cluster_info = function ()
	local red       = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local resp, err = red:call_command("sumavlib.suma_get_all_live_instance");
	close_redis(red);
	if err then
		return nil;
	end

	return resp;
end


_M.suma_code_set = function (k, val)
	local key = _M.build_code_key () .. k .. ".code_cache";
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip");
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local ok,err2 = red:set (key,  val);
	if not ok then
		ngx.log(ngx.ERR, "save code failed");
		close_redis(red);
		ngx.log(ngx.ERR, tostring(err2));
		return;
	end
	close_redis(red);
end

_M.suma_code_get = function (k)
	if k == nil then
		return nil;
	end
	local key = _M.build_code_key () .. tostring(k) .. ".code_cache";
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port);

	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local ok,err2 = red:get (key);
	-- ngx.log(ngx.ERR, 'key' .. tostring(ok));
	-- ngx.log(ngx.ERR, '' .. tostring(err2));
	if err2 then
		ngx.log(ngx.ERR, "get code failed" .. err2);
		close_redis(red);
		return nil;
	end
	close_redis(red);
	return ok;
end
-----------------------server project add ------------------------------
_M.build_project_key = function ()
	local bid =  _M.buiness_id;
	local oid =  _M.owner_id;
	if ngx.ctx.buiness_id  then
		bid = ngx.ctx.buiness_id ;
	end
	if ngx.ctx.token then
		oid = ngx.ctx.token;
	end
	local key = oid .. bid .. ".project";
	return  key
end

_M.build_project_exits = function ()
	return  _M.owner_id .. _M.buiness_id .. ".project.unique";
end

_M.build_project_incr = function ()
	return  _M.owner_id .. _M.buiness_id .. ".project.incr";
end
------
--- project 删除项目
------
_M.suma_project_delete = function (project_id)
	local key     = _M.build_project_key();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end

	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local ok, err2 = red:hdel (key , project_id);
	close_redis(red);
	if not ok then
		return false;
	end

	if err2 then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err2)
		return false;
	end

	return true;
end

_M.suma_project_get  = function (project_id)
	local key     = _M.build_project_list_key();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local list,err2 = red:hget (key , project_id);
	close_redis(red);
	if not list then
		-- return list;
		ngx.log(ngx.ERR, "not find list data");
		return nil;
	end

	return list;
end

_M.suma_projects_update =function (field , data)
	local key     = _M.build_project_list_key();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local ok,err2 =  red:hset (key, field, data);
	if not ok then
		close_redis(red);
		ngx.log(ngx.ERR, tostring(ok));
		return;
	end
	close_redis(red);
end

_M.suma_projects_delete = function (data)
	local key     = _M.build_project_list_key();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, err)
		return close_redis(red);
	end
	local ok,err2 = red:hdel (key , unpack(data));
	-- ngx.log(ngx.ERR, "cc =".. cjson.encode(ok))
	if not ok then
		return false;
	end

	local index_c , err  = red:zrem(key .. ".index", data[1]);
	close_redis(red);
	if err then
		ngx.log(ngx.ERR, "err=" .. tostring(err));
	end
	if err2 then
		ngx.log(ngx.ERR, "err=" .. tostring(err2));
		return false;
	end

	return true;
end

------
--- project 项目列表
------
-- ZREVRANGEBYSCORE owneridbuinessid.project.index  +inf -inf

_M.build_project_list_key = function ()
	local oid = "";

	if ngx.ctx.token then
		oid =  ngx.ctx.token;
	end

	return oid .. "project.list";
end
_M.suma_projects_list = function (page_id, page_size)
	local key     = _M.build_project_list_key();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err);
		return close_redis(red);
	end

	local data, err2  = red:zrevrangebyscore( _M.build_project_indexer_key(), "+inf" , "-inf");
	local result = {};
	result.data  = {};
	for index, value in ipairs(data) do
		local tmp = red:hget(key , value);
		if  tmp then
			result.data[#result.data + 1] = tmp;
		end
	end
	close_redis(red);
	result.code = 0;
	return result;
end

------
--- project 删除项目
------
_M.suma_project_remove_all = function ()
	local key     = _M.build_project_key();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local ok,err2 = red:del (key);
	close_redis(red);
	if not ok then
		return false;
	end

	if err2 then
		return false;
	end

	return true;
end
------
--- project 添加项目
------
_M.build_project_indexer_key = function ()
	local oid = "";
	if ngx.ctx.token then
		oid = ngx.ctx.token ;
	end
	local key = oid .. ".index"
	return key;
	-- return _M.build_project_key() .. ".index";
end


_M.suma_project_add = function (project_id , str)
	local key = _M.build_project_list_key();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port);
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local ok,err2 =  red:hset (key, project_id, str);
	if err2 then
		close_redis(red);
		ngx.log(ngx.ERR, tostring(err2));
		return;
	end
	red:zadd ( _M.build_project_indexer_key(),  project_id, project_id) ;
	close_redis(red);
end

----
--
----

------
--- project 唯一锁获取
------
_M.suma_unique_project_get = function (id)
	local key  = _M.build_project_exits();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local ok, err2 = red:hget (key , id);

	-- local status = tonumber(ok);
	close_redis(red);
	if not ok then
		return false;
	end
	return true;
end

------
--- project 唯一自增id
------
_M.suma_incr_unique_index = function ()
	local incr_key = _M.build_project_incr();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		close_redis(red);
		return 0;
	end

	local ok, err2 = red:incr (incr_key);
	close_redis(red);
	if err2 then
		ngx.log(ngx.ERR, err2);
		return 0;
	end
	-- ngx.log(ngx.ERR, "number = " .. tonumber(ok));
	return tonumber(ok);
end
------
_M.suma_unique_project_set = function (id)
	local key  = _M.build_project_exits();
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local ok, err2 = red:hset (key , id, 1);
	close_redis(red);
	if err2 then
		ngx.log(ngx.ERR, err2);
		return false;
	end
	return true;
end
----------------------
_M.build_book_key = function (id)
	return "book_" .. id;
end

_M.build_book_type = function (k)
	return "type_" .. k;
end
------
_M.type_book_type_set = function(index_key, book_id)
	local key     = _M.build_book_type (index_key);
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	red:zadd(key, 1, book_id);
	close_redis(red);
end
_M.comment_add_style    = function  (key, value)
	local detail_key  = key .. ".style"
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local id,err = red:lpush(detail_key, value);
	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end

	close_redis(red);
	return true;
end

_M.comment_add_new    = function  (key, value)
	local detail_key  = key .. ".detail"
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local id,err = red:hincrby(key, "total", 1);

	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end

	local id,err = red:lpush(detail_key, value);
	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end

	close_redis(red);
	return id;
end

_M.comment_get_data_meta    = function (key)
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local data,err = red:hmget(key,
	"ext"   , --cache url
	"roles" ,
	"type"  ,
	"keyword",
	"vote",
    "total" );
	
	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end
	close_redis(red);
	return data;
end
_M.comment_get_data    = function (key)
	local red     = redis:new();
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local data,err = red:hmget(key,
	"ext"   , --cache url
	"roles" ,
	"type"  ,
	"keyword",
	"vote",
    "total" );
	
	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end

	local style_key  = key .. ".style"

	local style,err = red:lrange(style_key, 0, -1);

	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end

	local detail_key  = key .. ".detail"
	local comment,err = red:lrange(detail_key, 0, -1);

	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end

	local data = {
		["meta"] = data,
		["style"]= style,
		["data"] = comment
	}

	return data;
end
_M.comment_add_indexer = function (key, ctype)
	local red     = redis:new();
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local data,err = red:hincrby(key, "total", 1);

	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end

	-- ngx.log(ngx.ERR , tostring(data))
	if 1 ~= data then
		close_redis(red);
		return nil ;
	end

	local data,err = red:hmset(key,
	    "ext"    , "" ,
		"roles"  , "" ,
		"comment", key .. ".detail",
		"type"   ,ctype,
		"style"  , key .. ".style",
		"keyword", "",
		"vote"   , 0
	);

	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end
	close_redis(red);
	return true;
end
_M.type_rnd_recommend_index_get = function (index_key, number)
	--获取最小元素
	local key     = _M.build_book_type (index_key);
	local red     = redis:new();
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	
	local limit = number - 1;
	if limit < 0 then
		limit = number;
	end

	local data,err = red:zrange(key, 0, limit);
	if err then
		ngx.log(ngx.ERR, err);
		close_redis(red);
		return nil ;
	end
	if data then
		--增加负载
		red:init_pipeline()
		for i, v in ipairs(data) do
			red:zincrby (key, 1, v);
		end

		red:commit_pipeline()
		--ZINCRBY key increment member
		close_redis(red);
		-- ngx.log(ngx.ERR, cjson.encode(data));
		--red:zincrby( myzset 2 "one"
		return data;
	end
	close_redis(red);
	return nil;
end

_M.get_books_by_search_indexers = function (idx)
	-- local len = #idx;
	ngx.log(ngx.ERR, "len=" .. #idx);
	local indexers = {}
	for k, v in ipairs(idx) do
		--v is array
		for k1, v1 in ipairs(v) do
		--ngx.log(ngx.ERR, v1) --单独索引
 			indexers [#indexers + 1] = v1;
		end
	end

	local data = _M.book_info_get_by_array(indexers)
	return data;
end

---确认是否有镜像推荐
_M.type_rnd_recommend_snap_get = function (book_id) 
	local key     = _M.build_rnd_recommend_key (book_id);
	local red     = redis:new();
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local data, err red:get(key);
	close_redis(red);

	return data;
end
_M.build_rnd_recommend_key = function (id) 
	return "snap_shot_" .. id
end

---制作镜像推荐
_M.type_rnd_recommend_snap_set = function (book_id, val) 
	local key     = _M.build_rnd_recommend_key (book_id);
	local red     = redis:new();
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local data, err = red:set(key, val);

	red:expire(key, 24*3600) ; --镜像时长
	close_redis(red);

	return data;
end
_M.book_info_get_by_array = function (arr)
	local data = {};
	local red     = redis:new();
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	red:init_pipeline()
	for i,v in ipairs(arr) do
		red:get(_M.build_book_key(v));
	end
	local results, err = red:commit_pipeline()
	if not results then
		close_redis(red);
		return
	end
	close_redis(red);
	return results;
end

_M.book_info_set = function(id, data)
	local key     = _M.build_book_key (id);
	local red     = redis:new();
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	red:set(key, data);
	close_redis(red);
end

_M.book_info_test = function(id)
	local key     = _M.build_book_key (id);
	local red     = redis:new();
	local ok, err = red  :connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	return red:get(key);
end


-----------------------本机API调用---------------------------------------
_M.call_local_interface = function (modu, method, func)
	if not modu then
		modu   = "suma_echo"
	end
	if not method then
		method = "hello"
	end
	-- if _M.local_api_cache == nil then
	local base  = "http://127.0.0.1";
	local port  = 80;
	if  _M.content_type() == "docker" then
		port = 8090;
	end

	base = base .. ":" .. port .. "/A/B/" .. modu .. "/" .. method .. ".mxml"
	local params = {
		ssl_verify = false,
		method     = "GET"
	}
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(base, params) ;
	if rres ~= nil then
		if  rres.body then
			return pcall(func, rres.body)
		end
	end
	return false, nil
end
-----------------------------内部调用----------------------------------
local http_jit  = require("suma_vip_http_jit");
local is_leader = _M.get_worker_is_leader;
local jit_get   = http_jit.vip_info_jit_get;
local jit_avg   = http_jit.avg;
local jit_load  = http_jit.load_calc;

--根据vip调用
_M.call_vip_interface = function (vip , modu, method, func , uri_prefix)
	local local_vip = jit_get (vip);
	if local_vip == nil then
		-- ngx.exit(403);
		ngx.log(ngx.ERR, "not find vip");
		return false, nil;
	end
	-- ngx.log(ngx.ERR, cjson.encode(local_vip));
	local remote_uri = "http://" .. local_vip.raw .. ":" .. local_vip.port ..
	"/" .. modu .. "/" .. method .. ".mxml?buiness_id=" .. ngx.ctx.buiness_id .. "&token =" .. ngx.ctx.token;
	if  uri_prefix ~= nil then
		remote_uri = remote_uri .. "?" .. uri_prefix;
	end

	-- ngx.log(ngx.ERR, "uri=" .. remote_uri);
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(remote_uri, {
	});
	if rerr ~= nil then
		ngx.log(ngx.ERR, rerr);
	end

	if rres ~= nil then
		--ngx.log(ngx.ERR, rres.body);
		return pcall(func, rres.body)
	end
	return false , nil ;
end

_M.get_worker_is_leader = function ()
	return tonumber(_M.get_to_cache("apollo_is_leader"));
end

_M.get_worker_master_vip = function () 
	return _M.get_to_cache("apollo_master_vip");
end

_M.set_to_cache   = function (key, value)
    local succ = cache_ngx:set(key, value)
    return succ
end

_M.get_to_cache   = function (key)
    return cache_ngx:get(key)
end

---构建发布订阅频道
_M.build_pubsub_channel = function ()
	local oid = _M.owner_id;
	local bid = _M.buiness_id;

	if ngx.ctx.token ~= nil then
		oid = ngx.ctx.token ;
	end

	if ngx.ctx.buiness_id ~= nil then
		bid = ngx.ctx.buiness_id;
	end
	return  oid .. bid .. "channel";
end

_M.empty_cmd_handle   = function () end
-----------------------------------------
_M.offline_state = false;
_M.localCmds.kill_vip = function ()
	_M.proxy_keep_alive = _M.empty_cmd_handle;
	_M.offline_state    = true;
end
_M.offline = function ()
	return _M.offline_state  ;
end

---底层钩子
---热更新
local build_hot_code_lock_key = function (t, id)
	if id then
		return 'code_lock_' .. t .. id;
	end
	return 'code_lock_' .. t .. ngx.worker.id();
end

_M.hot_code_reload = function (t)
	local status, lib = pcall(require , t);

	-- if status == true and lib == true then
	-- 	status = false;
	-- end
	if not status then
		-- 获取锁
		local k = build_hot_code_lock_key(t);
		local n = cache_ngx:incr(k , 1);
		if not n then
			cache_ngx:set(k, 0);
			n = 1;
		end

		-- ngx.log(ngx.ERR, 'CODE KEY' .. n)
		if n > 1 then
			-- ngx.log(ngx.ERR ,"cache");
			return true , _M["$" .. t];
		end

		--更新
		local code_c    = _M.get_to_cache("$" .. t) ;
		-- ngx.log(ngx.ERR, "code=" .. tostring(code_c));
		if code_c then
			local install_c = load(code_c) ;
			if install_c ~= nil then
				_M["$" .. t] = install_c();
				return true , _M["$" .. t];
			end
		end
		_M["$" .. t] = {}
		return true , _M["$" .. t];
	end
	-- ngx.log(ngx.ERR, "222")
	return true, lib;
end

_M.localCmds.set_hot_code = function (data)
	if data.token ~= _M.owner_id then
		ngx.log(ngx.ERR, "set hot code not find data.token")
		return;
	end

	if data.buiness_id ~= _M.buiness_id then
		ngx.log(ngx.ERR, "set hot code not find data.buiness_id")
		return;
	end
	if data.data ~= nil then
		local install_c = load(data.data) ;
		if install_c == nil then
			ngx.log(ngx.ERR, "[interface]" .. data.location .. "install failed.")
			return;
		end
		local jit_code  = c_dump(install_c);
		_M.set_to_cache("$" .. data.location, jit_code);
		local count = ngx.worker.count();
		for i=0,count,1 do
			local k = build_hot_code_lock_key( data.location, i);
			_M.set_to_cache(k , 0); ---上锁
		end
	end
	-- local status , m1 = _M.hot_code_reload(data.location);
end

_M.localCmds.reset_vip = function ()
	_M.offline_state = false;
	_M.proxy_keep_alive = _M.suma_keep_live;
	_M.try_keep_alive();
end
-----------------ci task -------------------------------
---
-- 各个主机处理handle
---
_M.localCmds.ci_task   = function ()
	local ci     = require("suma_ci_task_manager");
	local result = ci.run_task();
end

---
-- mem 上报
---
_M.build_vip_info_mem_key = function ()
	return _M.owner_id .. _M.buiness_id .. ".info";
end

_M.upload_vip_mem_info = function ()
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	red:hmset(_M.build_vip_info_mem_key() ,
		_M.get_to_cache("apollo_local_vip"),
		_M.get_to_cache("apollo_local_avg")
	)

	close_redis(red);
end

_M.build_vip_info_mem_key = function ()
	return _M.owner_id .. _M.buiness_id .. ".info";
end

_M.get_vip_mem_info = function ()
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local data,err = red:hscan(_M.build_vip_info_mem_key() ,
		0
	);

	if data then
		if data [2] ~= nil then
			local info  = data [2];
			local mset  = {}

			for i=1,#info,1 do
				if i % 2 == 0 then
					mset[info[i - 1]] =info[i];
				end
			 end
			 close_redis(red);
			 return mset;
		end
	end
	close_redis(red);
	return nil;
end
---
-- 开始ci任务
---
_M.build_ci_task_key = function ()
	return _M.build_master_key()
end

_M.ci_task_start = function ()
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local CONST_API_SUMA_CI_TASK="sumavlib.suma_ci_task"; 
	local resp, err = red:call_command(
		CONST_API_SUMA_CI_TASK,
		_M.build_pubsub_channel()
	)

	if nil ~= err then
		ngx.log(ngx.ERR, "task start err=" .. err);
	end
	close_redis(red);
	if resp then
		return 1;
	end
	return 0;
end
-----------------diamond config-------------------------
_M.localCmds.diamond_config = function (data)
	if data.path ~= nil  then
		local red     = redis:new();
		local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
		if proxy_ip ~= nil then
			redis_host = proxy_ip;
		end
		local ok, err = red:connect(redis_host, redis_port)
		if not ok then
			ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
			return close_redis(red);
		end
		local resp, err = red:get(data.path);
		if resp then
			local local_key = gsub (data.path, _M.build_pubsub_channel() , "");

			-- ngx.log(ngx.ERR, "local key=" .. local_key);
			_M.set_to_cache(local_key, resp);
			local curl =  _M.get_to_cache("web_hook")
			if  curl ~= nil then
				---post k v
				local params = {
					ssl_verify = false,
					method     = "POST"
				 };
				 params.headers = {};
				 params.headers ["Content-Type"]  = "application/json";
				 params.headers ["User-Agent"]    = "web hook"
				 local pack = {};
				 pack.key   = local_key;
				 pack.value = resp
				 params.body= cjson.encode(pack) ;
				 local httpd   = http.new();
				 local rres, rerr = httpd:request_uri(curl, params) ;
				 if rres == nil then
					close_redis(red);
				   return;
				 end
			end
			----web hook
		end
		close_redis(red);
	end
end

------------------------------------------
_M.suma_pubsub_listen = function ()
	local subscribe_ = function()
		local red = redis:new()
		red:set_timeout(60)  --- 60s timeout
		local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
		if proxy_ip ~= nil then
			redis_host = proxy_ip;
		end
		local ok, err = red:connect(redis_host, redis_port)
		if not ok then
			ngx.log(ngx.ERR, ERROR_REDIS_ERR , err)
			return
		end
		local channel = _M.build_pubsub_channel();
		local res, err = red:subscribe(channel)
		if not res then
			ngx.log(ngx.ERR, "failed to sub redis: ", err)
			return
		end
		while true do
			local res, err = red:read_reply()
			if res then
				if res[2] == channel  then --校验定制channel
					-- local item = cjson.encode(res);
					---内部命令 json
					-- ngx.log(ngx.ERR, "res=" .. tostring(res[3]));
					local data = cjson.decode(res[3]);
					if data then
						if data.type == 0 then
							--该机器私有
							-- data.vip = string.gsub(data.vip, " ", "") ;
							-- ngx.log(ngx.ERR, "res=" .. tostring(data.vip));
							if data.vip == _M.local_vip then
								if data.cmd then
									ngx.log(ngx.ERR, "recive " .. data.cmd);
									local func = _M.localCmds[data.cmd];
									if nil ~= func then
										func(data);
									end
								end
							end
						else
							--所有机器
							if data.cmd then
								ngx.log(ngx.ERR, "recive " .. data.cmd);
								local func = _M.localCmds[data.cmd];
								if nil ~= func then
									func(data);
								end
							end
						end
					end
				end
			else
			ngx.sleep(1);  ---非阻塞
			end
		end
	end
	local co = ngx.thread.spawn(subscribe_)
end

_M.build_master_key = function ()
	local oid = _M.owner_id;
	local bid = _M.buiness_id;

	if ngx.ctx.token ~= nil then
		oid = ngx.ctx.token;
	end

	if ngx.ctx.bid ~= nil then
		bid = ngx.ctx.bid;
	end

	return oid .. bid .. "master";
	-- return _M.owner_id .. _M.buiness_id .. "master";
end

_M.build_vip_key = function (key)
	local gen_key   =  tostring(ngx.encode_base64(key))
	gen_key = string.gsub(gen_key, "=", "");
	gen_key = string.gsub(gen_key, "=", "");
	_M.local_vip    = _M.owner_id .. _M.buiness_id ..".".. gen_key .. ".vip";
	_M.set_to_cache("apollo_local_vip", _M.local_vip )
	return _M.local_vip;
end

_M.build_vip_list_key = function ()
	local bid = _M.buiness_id;
	local oid = _M.owner_id;

	if ngx.ctx.token ~= nil then
		oid = ngx.ctx.token;
	end

	if ngx.ctx.buiness_id ~= nil then
		bid = ngx.ctx.buiness_id;
	end
	return oid .. bid .. "vip.list";
	-- return _M.owner_id .. _M.buiness_id .."vip.list"
end

_M.build_vip_indexer_key = function ()
	local bid = _M.buiness_id;
	local oid = _M.owner_id;

	if ngx.ctx.token ~= nil then
		oid = ngx.ctx.token;
	end

	if ngx.ctx.buiness_id ~= nil then
		bid = ngx.ctx.buiness_id;
	end

	return oid .. bid .. "*.vip";
	-- return _M.owner_id .. _M.buiness_id .. "*.vip";
end

_M.build_local_vip_value = function (vip)
	local bid = _M.buiness_id;
	local oid = _M.owner_id;

	if ngx.ctx.token ~= nil then
		oid = ngx.ctx.token;
	end

	if ngx.ctx.buiness_id ~= nil then
		bid = ngx.ctx.buiness_id;
	end

	return oid .. bid .. "*.vip";
	-- return _M.owner_id .. _M.buiness_id .. "*.vip";
end
-------------------diamond --------------------------

_M.build_diamond_list_key = function()
	---构建diamond search key
	return _M.build_pubsub_channel() .. "*";
end

_M.build_diamond_Item_key = function(k)
	if not k then
		k = ''
	end
	return _M.build_pubsub_channel() .. k;
end

_M.docker_incr_port_num = function (key)
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port);
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local num = red:incr(key);
	close_redis(red);
	return 9000 + tonumber(num);
end
---diamond 列表
_M.suma_diamond_list     = function ()
	local list_key = _M.build_diamond_list_key()
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local resp, err = red:call_command(
		CONST_API_DIAMOND_LIST,
		_M.build_diamond_list_key ());
	close_redis(red);

	if resp then
		return resp;
	end
	return {};
end


_M.suma_vip_kill = function (vip)
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)

	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local resp, err = red:call_command(
	CONST_API_SUMA_VIP_KILL,
	_M.build_pubsub_channel(),
	vip);
	close_redis(red);
	if resp then
		if 1 == tonumber(resp) then
			return 1;
		end
	end
	return 0;
end

_M.suma_vip_reset = function (vip)
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)

	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local resp, err = red:call_command(
	CONST_API_SUMA_VIP_RESET,
	_M.build_pubsub_channel(),
	vip);
	close_redis(red);
	if resp then
		if 1 == tonumber(resp) then
			return 1;
		end
	end
	return 0;
end

_M.suma_code_publish     = function (k, v)
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local cmd = {}
	cmd.type  = 1;
	cmd.cmd   = "set_hot_code";
	cmd.data  = v;

	if  ngx.ctx.token  ~= nil then
		cmd.token =  ngx.ctx.token;
	end

	if ngx.ctx.buiness_id ~= nil then
		cmd.buiness_id = ngx.ctx.buiness_id;
	end
	cmd.location = k;
	local cmd_str = cjson.encode(cmd);
	ngx.log(ngx.ERR, "cmd=" .. cmd_str)
	local resp, err = red:publish (_M.build_pubsub_channel(), cmd_str);
	close_redis(red);
	if resp then
		if 1 == tonumber(resp) then
			return 1;
		end
	end
	return 0;
end

_M.suma_diamond_publish  = function (k , v)
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	local key     = _M.build_diamond_Item_key(k)

	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end

	local resp, err = red:call_command(
	CONST_API_DIAMOND_PUBLISH,
	_M.build_pubsub_channel(),
	key,
	v);
	close_redis(red);
	if resp then
		if 1 == tonumber(resp) then
			return 1;
		end
	end
	return 0;
end
-------------------------------------------------------------

---[review20200328]
---
-- 竞选master
---
_M.pub_ex = 0;
_M.suma_try_leader  = function ()

	if _M.local_vip == nil then ---修复local_vip为空的问题
		return;
	end
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local resp, err = red:call_command(
	CONST_API_SUMA_TRY_LEADER,
	_M.build_master_key(),
	_M.local_vip);

	local setnx_res = tonumber(resp)

	if setnx_res == 1 then
		_M.is_leader = 1;
	else
		_M.is_leader = 0;
	end
	_M.set_to_cache("suma_apollo_isleader" , _M.is_leader);
	_M.proxy_keep_alive = _M.suma_keep_live ;
	-- ngx.log(ngx.ERR, "\n\n_M.is_leader=" .. _M.is_leader .. resp)
	if _M.pub_ex == 0 then
		ngx.timer.at(1,_M.suma_pubsub_listen); --注册成功后才可以pubsub
		_M.pub_ex = 1;
	end
	close_redis(red);
end


_M.suma_subtask_keep_live = function (v)
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)

	if not ok then
		 ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		 close_redis(red);
		 return false;
	end
	local resp, err = red:call_command(
	CONST_API_SUMA_KEEP_ALIVE,
	_M.build_master_key(),
	v.local_vip,
	v.search
	);

	if err ~= nil then
		ngx.log(ngx.ERR, "suma_subtask_keep_live=" .. err) ;
		lose_redis(red);
		return;
	end

	if not resp then
		close_redis(red);
		return false;
	end

	close_redis(red);
	return true;
end


---
-- 激活主机状态
---
_M.suma_keep_live = function ()
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)

	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR, err)
		return close_redis(red);
	end
	local resp, err = red:call_command(
	CONST_API_SUMA_KEEP_ALIVE,
	_M.build_master_key(),
	_M.local_vip,
	_M.build_vip_indexer_key()
	);

	if not resp then
		close_redis(red);
		_M.proxy_keep_alive = _M.suma_try_leader;
		return;
	end

	--如果目前没有leader的话
	if tostring(resp) == "0" then
		close_redis(red);
		_M.proxy_keep_alive = _M.suma_try_leader;
		return;
	end

	if 1 == _M.is_leader then
		if type (resp) ~= "number" and #resp > 0 then
			local live_vip_list =  cjson.encode(resp) ;
			_M.set_to_cache (_M.vip_list_cache_key, live_vip_list);
			_M.master_vip= _M.local_vip;
			local dc = _M.get_vip_mem_info();
			if dc ~= nil then
				local dd = cjson.encode(dc);
				_M.set_to_cache("master_avg_list" , dd);
			end
		end
	else
		_M.master_vip= tostring(resp);
	end
	close_redis(red);
	_M.set_to_cache("apollo_is_leader" , _M.is_leader);
	_M.set_to_cache("apollo_master_vip", _M.master_vip);
	_M.worker_inter_val_task();
end

_M.worker_inter_val_task = function ()
	cache_ngx:set("local_vip_limit_incr" ,0);
end
---
-- 设置缓存
---
_M.set_to_cache   = function (key, value, exptime)
    local cache_ngx = ngx.shared.ngx_share_dict;
	local succ, err, forcible = cache_ngx:set(key, value);
	return succ
end
---
-- 获取全部主机列表
---
_M.suma_vip_server_list = function  ()
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR , err)
		return close_redis(red);
	end
	local resp, err = red:call_command(
		CONST_API_SUMA_VIP_SERVER_LIST,
		_M.build_vip_list_key ()
	)
	close_redis(red);

	if resp then
		return resp;
	end
	return nil;
end

_M.suma_subtask_vip_server_list = function (v)
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR , err)
		return close_redis(red);
	end
	local resp, err = red:call_command(
		CONST_API_SUMA_VIP_SERVER_LIST,
		_M.build_subtask_vip_list_key (v)
	)
	close_redis(red);

	if resp then
		return resp;
	end
	return nil;
end

_M.build_ip_list_key = function ()
	return _M.owner_id .. _M.buiness_id .."vip.list"
end


---动态生成ip
_M.mms_raw_ip = nil;
function local_docker_ip_file_read()
	local f = io.open("/home/admin/ip", "r")
	if f == nil then
		return nil;
	end
	local d = f:read("*all")
	f:close();
	return d;
end

function local_docker_ip_file_write(ip)
	local f = io.open("/home/admin/ip", "w")
	if f == nil then
		return nil;
	end
	f:write(ip)
	f:close();
end

_M.gen_ip = function ()
	if _M.mms_raw_ip ~= nil then
		return _M.mms_raw_ip;
	end
	local docker_ip =  local_docker_ip_file_read();

	return docker_ip;
	-- if docker_ip ~= nil then
	-- 	_M.mms_raw_ip = docker_ip;
	-- 	return docker_ip;
	-- end

	-- docker_ip = "172."..math.random(255).. ".".. math.random(255) .. "." .. math.random(255);
	-- local_docker_ip_file_write(docker_ip);
	-- _M.mms_raw_ip = docker_ip;
	-- return  _M.mms_raw_ip;
end

--------------------------------------
--  vip 容器类型
--------------------------------------

_M.mcontianerType = nil;
_M.content_type = function  ()
	if _M.mcontianerType == nil then
		_M.mcontianerType = os.getenv("CONTAINER_TYPE");
	end
	return _M.mcontianerType;
end

---子任务注册


_M.build_subtask_vip_list_key = function (v)

		-- if ngx.ctx.token ~= nil then
	-- 	oid = ngx.ctx.token;
	-- end

	-- if ngx.ctx.buiness_id ~= nil then
	-- 	bid = ngx.ctx.buiness_id;
	-- end
	return v.owner_id .. v.biz_id .. "vip.list";
	-- return _M.owner_id .. _M.buiness_id .."vip.list"
end

_M.suma_subtask_register = function  (v)
	-- v.raw  =  _M.get_to_cache("apollo_local_ip2");
	--------------container type-------
	-- ngx.log(ngx.ERR, "subtask data =" .. cjson.encode(v));
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR , err)
		return close_redis(red);
	end
	local resp, err = red:call_command(
		CONST_API_SUMA_VIP_REGISTER,
		_M.build_subtask_vip_list_key(v),
		cjson.encode(v),
		v.local_vip 
	);
	close_redis(red);

	if resp then
		return resp;
	end
	return nil;
end


--------------------------------------
--  vip 开机注册
--------------------------------------
_M.suma_vip_register = function  ()
	local v = {}
	v.vip  =  _M.local_vip;
	v.ip   =  _M.get_to_cache("apollo_local_ip");
	v.raw  =  _M.get_to_cache("apollo_local_ip2");
	--------------container type-------
	local contentType = _M.content_type();
	if contentType == "docker" then
		v.type = "docker";
	else
		v.type = "mesh";
	end
	-----------------------------------
	v.port = os.getenv("APOLLO_PORT");
	if not v.port then
		v.port = 80;
	end

	ngx.log(ngx.ERR, "upload =" .. cjson.encode(v));
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR , err)
		return close_redis(red);
	end
	local resp, err = red:call_command(
		CONST_API_SUMA_VIP_REGISTER,
		_M.build_vip_list_key (),
		cjson.encode(v)
	);
	close_redis(red);

	if resp then
		return resp;
	end
	return nil;
end
---
-- 获取在线主机信息
---
_M.suma_vip_list = function ()
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR , err)
		return close_redis(red);
	end
	local resp, err = red:call_command(
	CONST_API_SUMA_VIP_LIST,
	_M.build_master_key(),
	_M.build_vip_indexer_key());
	close_redis(red);
	if not resp then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR , err) ;
		return nil;
	end
	if type(resp) == "string" then
		resp = {resp};
	end
	return resp;
end


---在线子任务虚拟主机信息
_M.suma_subtask_vip_list = function (v)
	-- if 1 then
	-- 	return nil;
	-- end
	local red     = redis:new();
	local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
	if proxy_ip ~= nil then
		redis_host = proxy_ip;
	end
	local ok, err = red:connect(redis_host, redis_port)
	if not ok then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR , err)
		return close_redis(red);
	end
	local resp, err = red:call_command(
	CONST_API_SUMA_VIP_LIST,
	"list",
	v.search);
	close_redis(red);
	if not resp then
		ngx.log(ngx.ERR, ERROR_REDIS_ERR , err) ;
		return nil;
	end
	if type(resp) == "string" then
		resp = {resp};
	end
	return resp;
end

_M.proxy_keep_alive = _M.suma_try_leader;
_M.try_keep_alive = function  ()
	return _M.proxy_keep_alive();
end


return _M;

