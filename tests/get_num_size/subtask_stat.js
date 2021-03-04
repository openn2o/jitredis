
/***
* subtask for js sdk1.0
*/
;(function (){
    var storage = window.localStorage;
    var subtask  = {
        "VERSION" : "v1.0", 
        "UPDATE"  : "2021/03/04",
        "COMMANDS": {}
    }
    var ERROR = {
        "NOT_FIND_CONFIG_MASTER_IP":function() {
            console.error("not find the master_ip in config");
        },
        "NOT_ALLOW_CONNECT_WEBSOCKET":function () {
            console.error("not allow connect the server " +  subtask.master_ip);
        },
        "NULL_PTR_RECIVE_DATA":function () {
            console.error("recive data is null ptr ");
        },
    }

    subtask.configure = function (config) {
        if(!config.master_ip) {
            ERROR("NOT_FIND_CONFIG_MASTER_IP");
            return;
        }
        subtask.master_ip = config.master_ip;
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
    }

    subtask.try_connect = function () {
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
 
    subtask.keep_alive = function () {
        if (!subtask.sock_connected) {
            return;
        }
    }
    return subtask;
})();