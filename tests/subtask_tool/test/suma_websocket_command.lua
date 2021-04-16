if not ngx then
	ngx = {}
end

local _M = {}
local cjson   = require "cjson"
local server  = require "suma_apollo_server"
local diamond = require("suma_diamond_client");
local vip_server = require("suma_vip_client")
local task_manager= require("suma_ci_task_manager")
local http = require "http"
local cache_ngx   = ngx.shared.ngx_share_dict;


----------------------------------------------------------------
-- task
local redis = require("suma_apollo_redis");
local MAX_TIME_OUT = 1000 * 3600 * 24;
_M.ws_ci_start = function (sock, data)
    ----how many live vip in server
    local vips   = server.suma_vip_list ();
    -- ngx.log(ngx.ERR, cjson.encode(vips));
    -- local vips =  {};
    local task_len= 0;
    if vips then
        if type(vips) == 'number' then
            sock:send_text("200");
            return;
        end
        task_len = #vips * #task_manager.tasks;
    end

    if task_len < 1 then
        sock:send_text("[suma_apollo] task num error.");
        return;
    end;

	local red = redis:new()
	red:set_timeout(MAX_TIME_OUT); --- 60s timeout

    local ok, err = red:connect(server.redis_host, server.redis_port);
    if not ok then
        ngx.log(ngx.ERR, "failed to sub redis: ", err)
        red:close();
        return
    end
    local channel = '__key*__:' .. server.build_ci_task_key() .. "*.ci"
-- ngx.log(ngx.ERR, "channel=" .. channel);
    local res, err = red:psubscribe(channel)
    if not res then
        ngx.log(ngx.ERR, "failed to sub redis: ", err)
        red:close();
        return
    end
    local co = ngx.thread.spawn(server.ci_task_start)
    while true do
        local res, err = red:read_reply()
        if err ~=  nil then
            break;
        end
        if res then
            if res then
                if res[4] ~=nil then
                    if res[4] == "set" then
                        if task_len  < 1 then
                            break;
                        end
                        local modifiy  = string.gsub(res[3], "__keyspace@0__:", "") ;
                        -- ngx.log(ngx.ERR, "key=" .. modifiy)
                        local content  = _M.get_task_content (modifiy);
                        -- ngx.log(ngx.ERR, "data=" .. content)
                        sock:send_text(content);
                        red:set_timeout(1000); --- 60s timeout
                        task_len = task_len - 1;
                    end
                end
            end
         end
    end
    ngx.thread.wait(co)
    -- ngx.log(ngx.ERR, "ngx close redis")
    sock:send_text("200"); ---结束
    red:close();
end

-- _M.filters = {};

_M.get_task_content = function (k)
    local red       = redis:new()
    local ok, err   = red:connect(server.redis_host, server.redis_port);
    local resp, err = red:get(k);
    red:close();
    if resp then
        return resp;
    end
    return nil;
end

----------------------------------------------------------------
-- 获取diamond 本机数据
_M.ws_suma_diamond_test = function (sock, data)
    local diamond_list = server.suma_diamond_list();
    local test_diamond_count = 0;
    if nil == diamond_list or tonumber(diamond_list) == 0 then
        sock:send_text("diamond length failed.");
    end
    test_diamond_count = #diamond_list;
    local key = server.build_pubsub_channel();
    local m_sub = string.gsub;
    local test_chk_count   = 0;
    local diamond_get = diamond.diamond_config_cache_get;
    for k, v in ipairs(diamond_list) do
        local local_k = m_sub(v, key, "");
        if diamond_get (local_k) ~= nil then
            test_chk_count = test_chk_count + 1;
        end
    end

    if test_chk_count == test_diamond_count then
        sock:send_text("diamond succ config.");
    else
        sock:send_text("diamond loss config.");
    end
end
--
-- mgrid 计算架构 diamond 基础计算
--
local ws_client = require("resty.websocket.client");
local http_jit  = require("suma_vip_http_jit");

local trace = function (str)
    ngx.log(ngx.ERR, str);
end

_M.co_pools  = {}

local ADebug = function (sock, str , callback)
    local log;
    if callback ~= nil then
        log = _M.response(str , callback);
    else
        log = _M.response(str , "ADebug");
    end
    sock:send_text(log)
end

_M.push_task = function (c, f, sock)
    local id = #c + 1
    c [id] =  coroutine.create(f);
end

local default_co_task = function (param, sock)
    ADebug(sock, cjson.encode(param))
end

_M.http_dynload_task= function (param, sock)
    -- ADebug(sock, cjson.encode(param))
    local params = {
		method   = "GET"
	}
	params.headers = {};
	params.headers ["Content-Type"]  = "application/json";
	local auth_url   = "http://127.0.0.1/suma/2015/suma_echo/status.mxml";
    local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	if rres ~= nil then
        ADebug(sock, rres.body, param.callback)
        return rres.body;
	end
	if rerr ~= nil  then
        ngx.log(ngx.ERR, rerr);
	end
    ADebug(sock, m, param.callback)
    return nil;
end


_M.http_hello_task = function (param, sock)
    -- ADebug(sock, cjson.encode(param))
    local params = {
		method   = "GET"
	}
	params.headers = {};
	params.headers ["Content-Type"]  = "application/json";
	local auth_url   = "http://127.0.0.1/suma/2015/suma_echo/status.mxml";
    local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	if rres ~= nil then
        -- ADebug(sock, rres.body)
        return rres.body;
	end
	if rerr ~= nil  then
        ngx.log(ngx.ERR, rerr);
	end
    -- ADebug(sock, m)
    return nil;
end

---
-- callback
local cache_ngx                   = ngx.shared.ngx_share_dict;

_M.ws_http_batch_start_command    = function (sock, params)
    cache_ngx:set("local_vip_limit_pass", 0)
    cache_ngx:set("local_vip_limit_forbid", 0)
    _M.co_pools    = {}
    local co_pools = _M.co_pools ;
    local co_num   = params.total or 1;
    local co_push  = _M.push_task;
    local method   = params.method or "default_co_task";
    local co_task  = nil;
    local status   = coroutine.status;
    if params.callback == nil then
        params.callback = method;
    end
------------获取算法
    if nil ~= _M[method] then
        co_task = _M[method];
    else
        co_task = default_co_task;
    end

    if co_task ~= nil then
        local step = 0;
        while  step < co_num do
            co_push(co_pools, co_task, sock)
            step = step+1;
        end
    end
------------启动
    for k, v in ipairs(co_pools) do
        if status(v) ~= "dead" then
            stat,mainre = coroutine.resume(v, params, sock)
        end
    end
------------
    local limit_pass  = cache_ngx:get("local_vip_limit_pass")
    local limit_forbid= cache_ngx:get("local_vip_limit_forbid")

    cache_ngx:set("local_vip_limit_pass", 0)
    cache_ngx:set("local_vip_limit_forbid", 0)
    return {
        ["pass"]  = limit_pass,
        ["limit"] = limit_forbid,
        ["total"] = co_num
    };
end

_M.ws_http_batch_start_command_0 = _M.ws_http_batch_start_command ;

_M.ws_suma_vipserver_limitrate_get_0 = function (sock,  data)
    local limit_rate_num =
    tonumber(server.get_to_cache("local_vip_limit"));
    -- ADebug(sock, "ws_suma_vipserver_limitrate_get_0" .. limit_rate_num);
    if limit_rate_num > 0 then
        -- ADebug(sock, "limit_rate_num=" .. limit_rate_num );
        return limit_rate_num;
    end
    -- return limit_rate_num;
    return 0;
end

_M.ws_suma_vipserver_limitrate_set_0 = function (sock,  data) 
    if data.limit ~= nil then
        server.set_to_cache("local_vip_limit" , data.limit);
        return data.limit;
    end
    return 0;
end

-------------------------------------------------------
-- mgrid 计算
-- agent.zy@aliyun.com
-------------------------------------------------------

_M.ws_mgrid_calc_cmd  = function (sock, params)
    local loc_vip     = params.vip;
    if not loc_vip then
        _M.ws_suma_command_params_err()
        return
    end
    local loc_vip_cache = http_jit.vip_info_jit_get(loc_vip)
    if not loc_vip_cache then
        ngx.log(ngx.ERR, "local vip cache");
        return;
    end
    local uri = "ws://" .. loc_vip_cache.ip .. ":" .. loc_vip_cache.port .. "/mgrid"
    local wb, err = ws_client:new {
        timeout = 5000,  -- in milliseconds
        max_payload_len = 65535
    }

    local ok, err = wb:connect(uri)
    if not ok then
        ngx.log(ngx.ERR, err)
        return
    end

    local bytes, err = wb:send_text(cjson.encode(params))
    if not bytes then
        ngx.log(ngx.ERR, err)
        return
    end

    local data, typ, err = wb:recv_frame()
    if not data then
        return
    end

    local bytes, err = wb:send_close()
    if not bytes then
        ngx.log(ngx.ERR, err)
        return
    end
    local mRes =  _M.response(data , "ws_mgrid_calc_cmd");
    sock:send_text(mRes);
end


-- diamond 获取本地数据
-- leader api
_M.ws_suma_diamond_get  = function (sock, data)
    if data.key ~= nil then
        local ret = diamond.diamond_config_cache_get(data.key);
        if ret ~= nil then
            sock:send_text(ret);
        else
            sock:send_text("");
        end
    else
        _M.ws_suma_command_params_err()
    end
end

---------------
-------- 添加项目
_M.invalidate_params = function (arr)
    for k, v in  ipairs(arr) do
        if v == nil then
            return false;
        end
    end
    return true;
end

_M.build_project_id = function ()
    local project_id =  ngx.encode_base64("" .. ngx.now());
    local end_s   =  #project_id  - 1;
    local start_s =  end_s - 5;
    project_id    =  string.sub(project_id, start_s, end_s);
    return project_id;
end

_M.ws_suma_project_update =function (sock, datac)
    local params = datac.data;
    if not datac.data then
        params = datac;
    end

    if not params then
        sock:send_text(_M.response({
            error= "params is empty" ,
            code = 2
        } , "ws_suma_project_update"));
        return;
    end
    local project_id = params["buiness_id"];
    if not project_id then
        sock:send_text(_M.response({
            error= "params is invalidate" ,
            code = 2
        } , "ws_suma_project_update"));
        return;
    end
    local owner_id = params ['token'];

    if owner_id == nil then
        sock:send_text(_M.response({
            error= "params is invalidate" ,
            code = 3
        } , "ws_suma_project_update"));
        return;
    end

    ngx.ctx.token = owner_id;
    local project_d = cjson.encode(params);
    server.suma_projects_update(project_id, project_d);
    sock:send_text(_M.response({
        data = data,
        error= "success" ,
        code = 0
    } , "ws_suma_project_update"));
end

_M.ws_suma_project_add = function (sock, datac)
    local params = datac.data;
    
    if not datac.data then
        params = datac;
    end
    if params.token then
        ngx.ctx.token = params.token;
    end

    if not params then
        sock:send_text(_M.response({
            error= "params is empty" ,
            code = 2
        } , "ws_suma_project_add"));
        return;
    end
    local project_id = server.suma_incr_unique_index();
    local data = params;
    data.project_id  = project_id;
    data.owner_id    = ngx.ctx.token;
    data.access_list   = 0;
    data.buiness_id    = project_id;
    ngx.ctx.buiness_id = project_id;
    data.app_container_list = 0;
    if params.project_desc ~= nil then
        data.project_desc = params.project_desc;
    end

    if params.project_name ~= nil then
        data.project_name = params.project_name ;
    end

    if params.visible ~= nil then
        data.visible = params.visible;
    end
    local project_d = cjson.encode(data);
    server.suma_project_add(project_id, project_d);
    sock:send_text(_M.response({
        data = data,
        error= "success" ,
        code = 0
    } , "ws_suma_project_add"));
end

--------------
----- 清空项目列表
--------------
_M.ws_suma_project_remove_all = function (sock, data)
    if server.suma_project_remove_all() then
        sock:send_text(_M.response({
            error= "" ,
            code = 0
        } , "ws_suma_project_remove_all"));
        return;
    end

    sock:send_text(_M.response({
        error= "" ,
        code = 3
    } , "ws_suma_project_remove_all"));
end
--------------
----- 项目列表
--------------

_M.ws_suma_projects_list = function (sock, data)
    if data.token then
        ngx.ctx.token = data.token;
    end

    if data.buiness_id then
        ngx.ctx.buiness_id = data.buiness_id;
    end

    if not data.page_id then
        data.page_id  = 0;
    end

    if not data.page_size then
        data.page_size = 10;
    end

    if data.page_size == -1 then
        data.page_size = 1000;
    end

    local results = server.suma_projects_list(data.page_id, data.page_size)
    data.code = 0;
    data.error= "";
    if results[2] ~= nil then
        data.data = results[2];
    end
    sock:send_text(_M.response(data , "ws_suma_projects_list"));
end

--------------
----- 删除项目
--------------
_M.ws_suma_project_delete = function (sock, data)
    if data.projects == nil then
        sock:send_text(_M.response({
            error= "" ,
            code = 4
        } , "ws_suma_project_delete"));
        return false;
    end

    if data.token == nil then
        sock:send_text(_M.response({
            error= "" ,
            code = 5
        } , "ws_suma_project_delete"));
        return false;
    end

    ngx.ctx.token = data.token;

    if #data.projects < 2 then
        local status = server.suma_projects_delete(data.projects);
        if status then
            sock:send_text(_M.response({
                error= "" ,
                code = 1
            } , "ws_suma_project_delete"));
            return false;
        end
    else
        local _stat = _M.suma_projects_delete(data.projects);
        if not _stat then
            sock:send_text(_M.response({
                error= "" ,
                code = 1
            } , "ws_suma_project_delete"));
            return false;
        end
    end

    sock:send_text(_M.response({
        error= "" ,
        code = 0
    } , "ws_suma_project_delete"));
    return true;
end

--------mgrid api
_M.ws_suma_diamond_get_0  = function (sock, data)
    -- ngx.log(ngx.ERR, cjson.encode(data));
    local ret = nil;
    if data.key ~= nil then
         ret = diamond.diamond_config_cache_get(data.key);
    end
    return ret;
end

--------mgrid api
_M.ws_suma_diamond_list_0 = function  (sock, data)
    local diamond_list = server.suma_diamond_list();
    local result_str  ;
    if nil == diamond_list or tonumber(diamond_list) == 0 then
        result_str = {}
    else
        local tmp = {}
        local key = server.build_pubsub_channel();
        local m_sub = string.gsub;
        for k, v in ipairs(diamond_list) do
            tmp[k]  = m_sub(v, key, "");
        end
        result_str = tmp;
    end
    return result_str;
end

-- diamond配置列表
-- review
-- leader api
_M.ws_suma_diamond_list = function  (sock, data)
    local diamond_list = server.suma_diamond_list();
    local result_str   = '[]'
    if nil == diamond_list or tonumber(diamond_list) == 0 then
        result_str   = '[]'
    else
        local tmp = {}
        local key = server.build_pubsub_channel();
        local m_sub = string.gsub;
        for k, v in ipairs(diamond_list) do
            tmp[k]  = m_sub(v, key, "");
        end
        result_str = cjson.encode(tmp)
    end
    sock:send_text(_M.response(result_str , "ws_suma_diamond_list"));
end

-- diamond发布配置
-- leader api
_M.ws_suma_diamond_publish = function  (sock, data)
    if not data then
        return;
    end

    if data.key then
        if not  data.value then
            data.value =  "";
        end
        local result = server.suma_diamond_publish(data.key, data.value)
        if result == 1 then
            sock:send_text( _M.response("{\"status\":1}" , "ws_suma_diamond_publish"));
        else
            sock:send_text( _M.response("{\"status\":0}" , "ws_suma_diamond_publish"));
        end
        return 
    end
    _M.ws_suma_command_params_err()
end
----------------------------------------------------
---- 主机状态
_M.response = function (data, sgin)
    local resp = {}
    resp.callback = sgin;
    resp.data     = data;
    return cjson.encode(resp)
end

_M.ws_suma_code_list_data = function (sock, data)

    if data.token then
        ngx.ctx.token = data.token;
    end

    if data.buiness_id then
        ngx.ctx.buiness_id = data.buiness_id;
    end

    local data = server.suma_code_list_data();
    ngx.log(ngx.ERR , cjson.encode(data));
    if not data then
        sock:send_text(_M.response({code=1} , "ws_suma_code_list_data"));
        return;
    end
    sock:send_text(_M.response( data , "ws_suma_code_list_data"));
end

_M.ws_suma_code_get  = function (sock, data)
    if data.token then
        ngx.ctx.token = data.token;
    end

    if data.buiness_id then
        ngx.ctx.buiness_id = data.buiness_id;
    end

     local func = {};
     if data.key == nil then
        func.code = 2;
        sock:send_text(_M.response(func , "ws_suma_code_get"));
        return;
     end
     local cdata = server.suma_code_get(data.key);
    --  ngx.log(ngx.ERR,  "cc=" .. cjson.encode(cdata));
     func.code  = 0;
     if data == nil then
        func.code = 1;
        sock:send_text(_M.response(func , "ws_suma_code_get"));
        return;
     end
     func.data  = cdata;
     sock:send_text(_M.response(func , "ws_suma_code_get"));
end

_M.ws_suma_code_save = function (sock, data)
    local func = {};
    func.code  = 0;

    if data.token then
        ngx.ctx.token = data.token;
    end

    if data.buiness_id then
        ngx.ctx.buiness_id = data.buiness_id;
    end

    if data.code == nil then
        func.code = 1;
        sock:send_text(_M.response(func , "ws_suma_code_save"));
        return;
    end

    if data.location == nil then
        func.code = 2;
        sock:send_text(_M.response(func , "ws_suma_code_save"));
        return;
    end
    server.suma_code_set(data.location, data.code);
    sock:send_text(_M.response(func , "ws_suma_code_save"));
end

--获取最近的版本
_M.ws_suma_publish_version_get = function (sock, data)
    local func = {};
    func.code  = 0;
    if data.token then
        ngx.ctx.token = data.token;
    end

    if data.buiness_id then
        ngx.ctx.buiness_id = data.buiness_id;
    end

    func.data  = server.suma_get_code_version ();
    sock:send_text(_M.response(func , "ws_suma_publish_version_get"));
end

_M.ws_suma_publish_version_code = function (sock, data)
    local func = {};
    func.code  = 0;

    if data.token then
        ngx.ctx.token = data.token;
    end
    if data.buiness_id then
        ngx.ctx.buiness_id = data.buiness_id;
    end

    if data.keyword == nil then
        func.code = 1;
        sock:send_text(_M.response(func , "ws_suma_publish_version_code"));
        return;
    end
    local version = nil; --roll back
    if data.version then
        server.suma_publish_code_save2(data.version);
        sock:send_text(_M.response(func , "ws_suma_publish_version_code"));
        func.version   = data.version;
        data.keywordey = data.version .."版本回滚"
        func.keyword   = data.keywordey ;
        return;
    else
        version = server.suma_publish_code_version();
        server.suma_publish_code_save(version);
        func.version = version;
        func.keyword = data.keywordey ;
    end

    server.suma_insert_code_version(version, data.keyword);
    sock:send_text(_M.response(func , "ws_suma_publish_version_code"));
end

_M.ws_suma_live_mod_publish = function (sock, data)
    local func = {}
    if data.code ~= nil and data.location ~= nil then
        local sandbox   = require ("suma_apollo_sandbox");
        local install_c = load(data.code) ;
        if not install_c then
            sock:send_text(_M.response("304" , "ws_suma_live_mod_publish"));
            return;
        end
        local install   = install_c();

        local qe = {quota=100};
        for k , v in pairs(install) do
            if type (v) == "function" then
                func [#func + 1] = k;
                local sf = sandbox.protect(v, qe)
                local status , err = pcall(sf)
                if err then
                    if tonumber(err) == -1 then
                        sock:send_text(_M.response("304" , "ws_suma_live_mod_publish"));
                        return ;
                    end
                end
            end
        end
        ---添加到持久化代码
        server.suma_code_set(data.location, data.code);
        server.suma_code_publish(data.location, data.code);
    end
    sock:send_text(_M.response(func , "ws_suma_live_mod_publish"));
end
------------------------创建虚拟资源-----------------

-- buiness_id: "29"
-- method_name: "as"
-- module_name: "as"
-- select_method: "GET"
-- select_vip: "EMzvQluiiHPzoVkgJq1ViSkAiEiE29.AzMx4CO24.vip"
-- token: "EMzvQluiiHPzoVkgJq1ViSkAiEiE"

_M.ws_suma_vip_call = function (sock, data)
    if data.token == nil then
        sock:send_text(_M.response("202" , "ws_suma_vip_call"));
        return;
    end

    if data.buiness_id == nil then
        sock:send_text(_M.response("202" , "ws_suma_vip_call"));
        return;
    end
    if data.buiness_id == nil then
        sock:send_text(_M.response("202" , "ws_suma_vip_call"));
        return;
    end

    if data.method_name == nil then
        sock:send_text(_M.response("202" , "ws_suma_vip_call"));
        return;
    end

    if data.module_name == nil then
        sock:send_text(_M.response("202" , "ws_suma_vip_call"));
        return;
    end

    if data.select_method == nil then
        sock:send_text(_M.response("202" , "ws_suma_vip_call"));
        return;
    end

    if data.select_vip == nil then
        sock:send_text(_M.response("202" , "ws_suma_vip_call"));
        return;
    end


    ngx.ctx.token      = data.token;
    ngx.ctx.buiness_id = data.buiness_id;
    server.call_vip_interface(data.select_vip, data.module_name, data.method_name, function (body)
        sock:send_text(_M.response(body , "ws_suma_vip_call"));
        return;
    end, '');

    -- sock:send_text(_M.response("200" , "ws_suma_vip_call"));
end
_M.suma_create_vres = function (sock, data)
    --创建虚拟资源
    if data.count == nil then
        sock:send_text(_M.response("202" , "suma_create_vres"));
        return;
    end
    if data.token == nil then
        sock:send_text(_M.response("203" , "suma_create_vres"));
        return;
    end
    if data.buiness_id == nil  then
        sock:send_text(_M.response("204" , "suma_create_vres"));
        return;
    end
	
	ngx.ctx.buiness_id = data.buiness_id;
	ngx.ctx.token      = data.token;
    ngx.log(ngx.ERR ,"create viruat resource");

    local n = tonumber(data.count);
    local open = io.open;
    local shell= "/tmp/" .. data.token .. ngx.now() .. ".sh"
    local file = open(shell, "w+");

    for i = 1, n, 1 do
        -- statements
        ngx.log(ngx.ERR, "create new container begin");
        -- local loc_ip = _M.gen_ip ();
        local loc_ip = server.get_to_cache("apollo_local_ip2");
        ngx.log(ngx.ERR, "1 create new container local ip ="  .. loc_ip);
        ngx.log(ngx.ERR, "1 create new container local vip =" .. _M.gen_vip (
            data.token,
            data.buiness_id,
            loc_ip
        ));
        local key = loc_ip .."/";
        local vo  = {}
        vo.port       = server.docker_incr_port_num (key);
        vo.native_port =server.docker_incr_port_num (key);
        vo.token  = data.token;
        vo.buiness_id = data.buiness_id;
        vo.ip     = loc_ip;
        local cmds = [[
            docker run -itd -v /home/admin/logs2:/home/admin/logs  \
            --env LOCAL_IP="]].. loc_ip ..[[" \
            --env CONTAINER_TYPE="docker" \
            --env APOLLO_OWNER_ID="]] .. data.token ..[[" \
            --env APOLLO_BUINESS_ID="]]..data.buiness_id..[[" \
            --env APOLLO_PORT=]]..vo.port..[[ \
            -p ]]..  vo.native_port ..[[:10082 -p ]].. vo.port ..[[:8090 \
            --rm  registry-1.docker.io/459733390/suma_apollo:latest
                ]]

        file:write(cmds .. "\n");
        ngx.log(ngx.ERR, "cmd= " .. cmds);
    end
    file:close();
    local myfile, err = io.popen("sh " .. shell,  "r");
    if nil == myfile then
        ngx.log(ngx.ERR,"open file for dir fail");
        return ;
    end
    if err ~= nil then
        ngx.log(ngx.ERR, "error =" .. err);
		return;
    end
	    --插入项目信息
    local project_data = server.suma_project_get(data.buiness_id);
	local insert_data  = nil ;
	if project_data ~= nil then
		insert_data = cjson.decode(project_data);
		if insert_data.app_container_list == 0 then
			insert_data.app_container_ids  = {};
		end
	else
		ngx.log(ngx.ERR, "insert data is null");
	end
	
    -- 读取文件内容
    while true do
        local cnt =  myfile:read("*line");
        if cnt == nil then
            break;
        end
		insert_data.app_container_ids[#insert_data.app_container_ids + 1] = cnt;
        ngx.sleep(1);
        sock:send_text(_M.response(cnt , "suma_create_vres"));
    end
    insert_data.app_container_list = #insert_data.app_container_ids;
    myfile:close();
    -- sock:send_text(_M.response("201" , "suma_create_vres"));
	ngx.log(ngx.ERR, "need insert data=" .. cjson.encode(insert_data));
	server.suma_projects_update(data.buiness_id, cjson.encode(insert_data));
end

_M.gen_ip = function ()
	local docker_ip = "172."..math.random(255).. ".".. math.random(255) .. "." .. math.random(255);
	return  docker_ip;
end
_M.gen_vip = function (owner_id, buiness_id, ip)
	local gen_key   =  tostring(ngx.encode_base64(ip)):reverse():sub(1, 10)
	gen_key = string.gsub(gen_key, "=", "");
	gen_key = string.gsub(gen_key, "=", "");
	return owner_id .. buiness_id ..".".. gen_key .. ".vip";
end


_M.suma_create_vres_0 = _M.suma_create_vres ;
-- ws_suma_diamond_list_0
----------------------------------------------------
-- kill vip
_M.ws_suma_kill_vip   = function  (sock, data)
    if data.vip == nil then
        sock:send_text(_M.response("202" , "ws_suma_kill_vip"));
        return;
    end
    if 1 == server.suma_vip_kill(data.vip) then
        sock:send_text(_M.response("200" , "ws_suma_kill_vip"));
        return;
    end
    sock:send_text(_M.response("201" , "ws_suma_kill_vip"));
end

-- reset vip
_M.ws_suma_reset_vip  = function  (sock, data)
    if data.vip == nil then
        sock:send_text(_M.response("202" , "ws_suma_reset_vip"));
        return;
    end 
    if 1 == server.suma_vip_reset(data.vip) then
        sock:send_text(_M.response("200" , "ws_suma_reset_vip"));
        return;
    end
    sock:send_text(_M.response("201" , "ws_suma_reset_vip"));
end

--
-- 获取集群信息
--
_M.ws_suma_subtask_cluster_data = function (sock, data)
	local loc1 = {}
	loc1.owner_id  = server.owner_id ;
	loc1.biz_id    = data.biz_id;
    local vips = cache_ngx:get ( loc1.owner_id .. loc1.biz_id .. ".cluster.cache" );
    if nil  == vips then
		ngx.log(ngx.ERR, "not find the service for subtask");
		return {};
    end
    sock:send_text(_M.response(vips , "ws_suma_subtask_cluster_data"));
end
_M.ws_suma_get_all_cluster_names = function (sock,  data)
    local vips = server.suma_get_all_cluster_names()
    sock:send_text(_M.response(vips , "ws_suma_get_all_cluster_names"));
end

_M.ws_suma_subtask_all_cluster_live_data = function (sock,  data)
    local vips = server.all_live_cluster_info()
    sock:send_text(_M.response(vips , "ws_suma_subtask_all_cluster_live_data"));
end

_M.ws_suma_subtask_all_cluster_data = function (sock,  data)
    local vips = server.all_cluster_info()
    sock:send_text(_M.response(vips , "ws_suma_subtask_all_cluster_data"));
end

_M.ws_suma_subtask_tracker_data = function (sock, data)
    -- local idx =  tonumber(cache_ngx:get("rec_idx")) ;
    -- ngx.log(ngx.ERR, "len=" .. idx);
    local _biz = require("suma_biz_inter");
    local data = _biz.tracker_fetch ();
    local idx  = table.getn(data);

    ngx.log(ngx.ERR, "idx=" .. idx);
    -- local start = 1;
    -- local tmp   = {};
    -- while start <= idx do
    --     tmp[start] = data[start];
    --     start = start + 1;
    -- end

    if idx < 1 then
        sock:send_text(_M.response("" , "ws_suma_subtask_tracker_data"));
        return;
    end
    sock:send_text(_M.response(table.concat(data) , "ws_suma_subtask_tracker_data"));
end


_M.subscribe = function  (sock, data)
local subscribe_ = function()
    local red = redis:new()
    red:set_timeout(3600*24)
    local proxy_ip  = cache_ngx:get("cluster_data_center_ip") 
    local ok, err   = red:connect(proxy_ip, 6379)
    if not ok then
        ngx.log(ngx.ERR, ERROR_REDIS_ERR , err)
        return
    end

    local channel = "warn_report_channel";
    local res, err = red:subscribe(channel)
    if not res then
        ngx.log(ngx.ERR, "failed to sub redis: ", err)
        return
    end
    while true do
        if sock == nil then
            ngx.log(ngx.ERR, "close===============");
            red:close();
            return;
        end
        local res, err = red:read_reply()
        red:set_keepalive(60000)
        if err then
            ngx.log(ngx.ERR, "err=" .. err);
            red:close();
            return;
        end
        if res then
            if res[2] == channel  then --校验定制channel
                ngx.log(ngx.ERR, "res=" .. tostring(res[3]));
                sock:send_text(_M.response( res[3] , "ws_subscribe"));
            end
        else
        ngx.sleep(1);  ---非阻塞
        end
    end
end
    local co = ngx.thread.spawn(subscribe_)
end

--leader api
_M.ws_suma_vip_status = function  (sock, data)
    local result    = {}
    local result_str = '[]';
    if data.token == nil then
        result.code = 402;
        result_str = _M.response(result,  "ws_suma_vip_status")
        sock:send_text(result_str);
        return
    end

    if data.buiness_id == nil then
        result.code = 403;
        result_str = _M.response(result,  "ws_suma_vip_status")
        sock:send_text(result_str);
        return;
    end

    ngx.ctx.token      = data.token;
    ngx.ctx.buiness_id = data.buiness_id;
    local live_list = server.suma_vip_list();
    local owner_list= server.suma_vip_server_list();
    if owner_list ~= nil and 0 ~= tonumber(owner_list) then
        for k, v in ipairs(owner_list) do
            local _d, _obj = pcall(cjson.decode, v);
            if _d then
                if _obj.vip ~= nil then
                    result [_obj.vip] = _obj;
                    result [_obj.vip].status = false;
                end
            end
        end
    end
    
    local master_vip = server.get_to_cache("apollo_master_vip");
    if tonumber(live_list) ==  0 then
        result_str = _M.response(result,  "ws_suma_vip_status")
        sock:send_text(result_str);
        return;
    end
    if live_list ~= nil then
        for k, v in ipairs(live_list) do
            if result[v] ~= nil then
                if master_vip ~= nil then
                    if master_vip == result[v].vip then
                        result[v].isleader = true;
                    else
                        result[v].isleader = false;
                    end
                end
                result[v].status = true;
            end
        end
    end
    result_str = _M.response(result,  "ws_suma_vip_status")
    sock:send_text(result_str);
end

_M.ws_suma_command_recive_succ = function (sock, data) 
    sock:send_text("[suma_apollo] recive " .. data);
end
_M.ws_suma_command_uncaght_err = function (sock) 
    sock:send_text("[suma_apollo] uncaght error. ");
end
_M.ws_suma_command_syntax_err = function (sock) 
    sock:send_text("[suma_apollo] command syntax error.");
end
_M.ws_suma_command_notimplement_err = function (sock) 
    sock:send_text("[suma_apollo] command not implements error.");
end
_M.ws_suma_command_params_err = function (sock)
    sock:send_text("[suma_apollo] command params error.");
end




return _M;