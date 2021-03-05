
/***
* subtask for js sdk1.0
*/
;(function (){
    var storage = window.localStorage;
    var time_at = setTimeout;
    var default_err_out = function (message) {}
    var error_c = console.error;
    var subtask  = {
        "VERSION" : "v1.0", 
        "COMMANDS": {}
    }
    var ERROR = {
        "NOT_FIND_CONFIG_MASTER_IP":function() {
            error_c("not find the master_ip in config");
        },
        "NOT_ALLOW_CONNECT_WEBSOCKET":function () {
            error_c("not allow connect the server " +  subtask.master_ip);
        },
        "NULL_PTR_RECIVE_DATA":function () {
            error_c("recive data is null ptr ");
        },
        "MESSAGE_FORMAT_ERR":function () {
            error_c("recive data syntax error ");
        },
        "MESSAGE_NOT_IMPLEMENTION" : function () {
            error_c("recive data syntax error ");
        }
    }

    subtask.cmds = {

    }

    subtask.connect_subtask_loadavg = function () {
        subtask.sock_connected  = true;
    }

    subtask.disconnected_subtask_loadavg = function () {
        subtask.sock_connected  = false;
    }

    subtask.recive_subtask_loadavg_message = function (json_str) {
        if (!json_str) {
            ERROR("NULL_PTR_RECIVE_DATA");
            return;
        }
        var cjson = null;
        try {
            cjson = JSON.parse(json_str) ;
        } catch (e) {
            //////// 40x-50x
        }
        //////////ping - pong
        if (cjson == null) { 
            return;
        }
        //////////parse cmd
        if (!cjson.cmd) {
            ERROR("MESSAGE_FORMAT_ERR");
            return;
        }
        ////////// message handler
        if (subtask.cmds [cjson.cmd] != null) {
            subtask.cmds [cjson.cmd](cjson);
        } else {
            ERROR("MESSAGE_NOT_IMPLEMENTION");
        }
    }

    subtask.try_connect = function () {
        if(subtask.sock_connected) {
            return;
        }

        if(!config.master_ip) {
            ERROR("NOT_FIND_CONFIG_MASTER_IP");
            return;
        }
        try {
            subtask.sock = new WebSocket(subtask.master_ip);
        } catch (e) {	
            ERROR("NOT_ALLOW_CONNECT_WEBSOCKET");
        }

        subtask.sock.onopen   = subtask.connect_subtask_loadavg;
        subtask.sock.onclose  = subtask.disconnected_subtask_loadavg;
        subtask.sock.onmessage= subtask.recive_subtask_loadavg_message;
    }
 
    subtask.keep_alive = function (subtask) {
        if (!subtask.sock_connected) {
            return;
        }
        if (subtask.sock != null) {
            subtask.sock.send("ping");  // this is keep alive connection.
        }
        time_at(subtask.keep_alive, 30, subtask);
    }

    subtask.start = function (config) {
        if(!config.master_ip) {
            ERROR("NOT_FIND_CONFIG_MASTER_IP");
            return;
        }
        subtask.master_ip = config.master_ip;
        subtask.keep_alive ();
    }

    return subtask;
})();