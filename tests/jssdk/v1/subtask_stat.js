
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
    subtask.user_handle = {
    	"error":function (e) {
    		console.log("error::" + e);
    	}
    }
    subtask.cmds = {
    	/**获取某个biz_id业务集群详细信息*/
    	"get_subtask_biz_cluster_info_detail" : function (subtask, biz_id, func) {
    		  if(!subtask.sock_connected) {
			      return;
			  }
    		  if(!biz_id) {
    		  	biz_id = "sumanri";
    		  }
    		  subtask.user_handle ["ws_suma_subtask_cluster_data"] = func;
    		  subtask.sock.send(subtask.pack_message({
		    	 "command":"ws_suma_subtask_cluster_data",
		    	 "data":{
		        	"biz_id" : biz_id
		    	  }
		      }));
    	},
    	/*获取所有集群信息*/
    	"get_subtask_all_cluster_info_detail" : function (subtask, func) {
    		  if(!subtask.sock_connected) {
			      return;
			  }
    		  subtask.user_handle ["ws_suma_subtask_all_cluster_data"] = func;
    		  subtask.sock.send(subtask.pack_message({
		    	 "command":"ws_suma_subtask_all_cluster_data",
		    	 "data":{}
		      }));
    	},
    	/***
    	 * 获取所有在线的实例
    	 */
    	"get_all_live_instance":function (subtask, func) {
    		  if(!subtask.sock_connected) {
			      return;
			  }
    		  subtask.user_handle ["ws_suma_subtask_all_cluster_live_data"] = func;
    		  subtask.sock.send(subtask.pack_message({
		    	 "command":"ws_suma_subtask_all_cluster_live_data",
		    	 "data":{}
		      }));
    	},
    	/***
    	 * 获取所有集群的名称
    	 */
    	
    	"get_all_cluster_names":function (subtask, func) {
    		  if(!subtask.sock_connected) {
			      return;
			  }
    		  
    		  if(subtask.cache["ws_suma_get_all_cluster_names"]) {
    		  	return subtask.cache["ws_suma_get_all_cluster_names"];
    		  }
    		  subtask.user_handle ["ws_suma_get_all_cluster_names"] = func;
    		  subtask.sock.send(subtask.pack_message({
		    	 "command":"ws_suma_get_all_cluster_names",
		    	 "data":{}
		      }));
    	},
    	"ws_subscribe":function (subtask, func) {
    	}
    }
    
	subtask.cache = {};
	subtask.handle = {
		"ws_suma_subtask_cluster_data": function (subtask, e) {
				try {
					var json_r = JSON.parse(e) ;
					
					if (json_r [0]) {
						json_r = JSON.parse(json_r [0])
					}
					if(subtask.user_handle ["ws_suma_subtask_cluster_data"] != null) {
						subtask.user_handle ["ws_suma_subtask_cluster_data"](json_r);
					}
				} catch (e) {
					subtask.user_handle ["error"](e);
				}
		 },
		 "ws_suma_subtask_all_cluster_data" : function (subtask, e) {
		 		try {
					subtask.cache["ws_suma_subtask_all_cluster_data"] = [];
					var retVal  = [];
					var json_r  = e;
					var fliters = {}
					for(var i = 0; i< json_r.length; i++) {
						if (!json_r[i]) continue;
						var o = JSON.parse(json_r[i]);
						if (o.biz_id && !fliters[o.local_vip]) {
							retVal.push(o);
							subtask.cache["ws_suma_subtask_all_cluster_data"] = retVal;
							fliters [o.local_vip] = 1;
						}
					}
					
					if(subtask.user_handle ["ws_suma_subtask_all_cluster_data"] != null) {
						subtask.user_handle ["ws_suma_subtask_all_cluster_data"](retVal);
					}
				} catch (e) {
					subtask.user_handle ["error"](e);
				}
		 },
		 "ws_suma_subtask_all_cluster_live_data": function (subtask, e) {
		 	var keys  = e;
		 	var caches   = subtask.cache["ws_suma_subtask_all_cluster_data"];
		 	if(!caches) {
		 		return;
		 	}
		 	
		 	var len = e.length;
		 	var tmp = [];
		 	for(var i = 0; i < len ; i ++) {
		 		
		 		for(var k in caches) {
		 			if(caches[k].local_vip == e[i]) {
		 				tmp.push(caches[k]);
		 			}
		 		}
		 	}
		 	if(subtask.user_handle ["ws_suma_subtask_all_cluster_live_data"] != null) {
				subtask.user_handle ["ws_suma_subtask_all_cluster_live_data"](tmp);
			}
		 },
		 "ws_suma_get_all_cluster_names" : function (subtask,  e) {
		 	var retVal = e;
		 	if(retVal.length < 1) {
		 		return;
		 	}
		 	subtask.cache["ws_suma_get_all_cluster_names"] = [];
		 	var tmp = [];
		 	for(var i = 0; i < retVal.length ; i++) {
		 		var fristName = e[i].substring(4, e[i].indexOf("vip.list"));
		 		
		 		if(fristName == "Drm") {
		 			continue;
		 		}
		 		tmp.push(fristName);
		 	}
		 	
		 	if(subtask.user_handle ["ws_suma_get_all_cluster_names"] != null) {
				subtask.user_handle ["ws_suma_get_all_cluster_names"](tmp);
			}
		 },
		 "ws_subscribe" : function (subtask,  e) {
		 	var cjson_r = JSON.parse(e);
		 	var i = -1;
		 	if ((i =cjson_r.data.indexOf(".list")) != -1) {
		 		cjson_r.data = cjson_r.data.substring(4,i);
		 	}
		 	
		 	cjson_r.time = Number(cjson_r.time);
		 	
		 	if(subtask.user_handle ["ws_subscribe"] != null) {
				subtask.user_handle ["ws_subscribe"](cjson_r);
			}
		 }
    }
	
    subtask.connect_subtask_loadavg = function () {
        subtask.sock_connected  = true;
        subtask.keep_alive (subtask);
        
        if (subtask.on_start!=null) {
        	subtask.on_start ();
        }
    		  
		subtask.sock.send(subtask.pack_message({"command":"subscribe"}));
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
            subtask.handle [cjson.callback](subtask, cjson.data);
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

	subtask.subscribe = function (func) {
		subtask.user_handle ["ws_subscribe"] = func;
	}
	
    subtask.start = function (config , func) {
        if(!config.master_ip) {
            ERROR("NOT_FIND_CONFIG_MASTER_IP");
            return;
        }
        subtask.on_start  = func;
        subtask.master_ip = config.master_ip;
        subtask.try_connect();
        return subtask;
    }

	for(var k in subtask.cmds) {
		subtask[k] = subtask.cmds[k];
	}
	subtask.start     = subtask.start;
	window.subtask     = subtask;
})();