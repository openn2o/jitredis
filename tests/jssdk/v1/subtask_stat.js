
/***
* subtask for js sdk1.0
*/
;(function (){
    var storage = window.localStorage;
    var time_at = setTimeout;
    var error_c = console.error;
    var subtask = {
        "VERSION" : "v1.0"
    }
    subtask.sock_connected = false;
    subtask.master_ip      = null;
    
    var ERROR = {
        "NOT_FIND_CONFIG_MASTER_IP":function() {
            error_c("not find the master_ip in config");
        },
        "NOT_ALLOW_CONNECT_WEBSOCKET":function() {
            error_c("not allow connect the server " +  subtask.master_ip);
        },
        "NULL_PTR_RECIVE_DATA":function() {
            error_c("recive data is null ptr ");
        },
        "MESSAGE_FORMAT_ERR":function() {
            error_c("recive data syntax error ");
        },
        "MESSAGE_NOT_IMPLEMENTION":function () {
            error_c("recive data syntax error ");
        }
    }
    
    subtask.pack_message= function (v) {
    	return JSON.stringify(v);
    }
    
    subtask.cmds = {
    	/**获取某个biz_id业务集群信息处理*/
    	"get_subtask_cluster_info_by_biz" : function (subtask, biz_id) {
    		  if(!subtask.sock_connected) {
			      return;
			  }
    		  
    		  if(!biz_id) {
    		  	biz_id = "sumanri";
    		  }
    		  
    		  biz_id = ";";
    		  subtask.sock.send(subtask.pack_message({
		    	 "command":"ws_suma_subtask_cluster_data",
		    	 "data":{
		        	"biz_id" : biz_id
		    	  }
		      }));
    	}
    }
	
	subtask.handle = {
		"ws_suma_subtask_cluster_data": function (subtask, e) {
				console.log(e);
		 }
    }

	
    subtask.connect_subtask_loadavg = function () {
        subtask.sock_connected  = true;
        subtask.cmds["get_subtask_cluster_info_by_biz"](subtask);
        console.log(subtask.cmds["get_subtask_cluster_info_by_biz"]);
        subtask.keep_alive (subtask);
    }

    subtask.disconnected_subtask_loadavg = function () {
        subtask.sock_connected  = false;
        console.warn("bye.")
    }

    subtask.recive_subtask_loadavg_message = function (json_str) {
        if (!json_str.data) {
            ERROR("NULL_PTR_RECIVE_DATA");
            return;
        }
        var cjson = null;
        try {
            cjson = JSON.parse(json_str.data) ;
        } catch (e) {
            //////// 40x-50x or error
            console.error(json_str.data);
            return;
        }
        //////////ping - pong
        if (cjson == null) { 
        	console.error(json_str.data);
            return;
        }
        //////////parse cmd
        if (!cjson.callback) {
            ERROR("MESSAGE_FORMAT_ERR");
            return;
        }
        ////////// message handler
        if (subtask.handle [cjson.callback] != null) {
            subtask.handle [cjson.callback](cjson);
        } else {
            ERROR("MESSAGE_NOT_IMPLEMENTION");
        }
    }

    subtask.try_connect = function () {
        if(subtask.sock_connected) {
            return;
        }
        
        if (subtask.sock != null) {
        	return;
        }

        if(!subtask.master_ip) {
            ERROR("NOT_FIND_CONFIG_MASTER_IP");
            return;
        }
        try {
            subtask.sock = new WebSocket("ws://" + subtask.master_ip +":8091/mtask");
        } catch (e) {	
            ERROR("NOT_ALLOW_CONNECT_WEBSOCKET");
        }

        subtask.sock.onopen   = subtask.connect_subtask_loadavg;
        subtask.sock.onclose  = subtask.disconnected_subtask_loadavg;
        subtask.sock.onmessage= subtask.recive_subtask_loadavg_message;
    }
 
    subtask.keep_alive = function (subtask) {
        if (!subtask.sock_connected) {
        	ERROR("NULL_PTR_RECIVE_DATA");
            return;
        }
        if (subtask.sock != null) {
            subtask.sock.send("ping");  // this is keep alive connection.
        }
        time_at(subtask.keep_alive, 15000, subtask);
    }

    subtask.start = function (config) {
        if(!config.master_ip) {
            ERROR("NOT_FIND_CONFIG_MASTER_IP");
            return;
        }
        subtask.master_ip = config.master_ip;
        subtask.try_connect();
    }
	var _subtask  = {};

	for(var k in subtask.cmds) {
		_subtask[k] = subtask.cmds[k];
	}
	_subtask.start     = subtask.start;
	window.subtask = _subtask;
})();