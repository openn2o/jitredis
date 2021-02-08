
/***
 * suma 分布式模块 
 */

 #define REDISMODULE_EXPERIMENTAL_API 1


#include <stdlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include "redismodule.h"
#define TIME_OUT_NUM 3000

/***
* suma_ci_task
*/
int suma_ci_task (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
  
	 
    RedisModule_AutoMemory(ctx);
    ///pub
    RedisModuleString *scmd = RedisModule_CreateStringPrintf(ctx,  "{\"type\":1, \"cmd\":\"ci_task\"}");
       
    #if ALLOW_TRACE == 1
         RedisModule_Log(ctx ,  "warning", "suma_ci_task %s",  RedisModule_StringPtrLen(scmd, NULL));
    #endif

    RedisModuleCallReply *pub_status_int = RedisModule_Call(ctx, "PUBLISH", "ss", argv [1], scmd);

    if (REDISMODULE_REPLY_INTEGER == RedisModule_CallReplyType(pub_status_int)) {
         long long status = RedisModule_CallReplyInteger(pub_status_int);
         if (status > 0) {
              RedisModule_ReplyWithLongLong(ctx, 1);
              return  REDISMODULE_OK;
         }
    }

    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}

//TODO ..
int suma_diamond_delete (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
	
    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}
///获取所有vip列表
int suma_vip_server_list (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
	 REDISMODULE_NOT_USED(argv);
     REDISMODULE_NOT_USED(argc);
     if (argc < 2) {
        return RedisModule_WrongArity(ctx);
     }
	 
	  #if ALLOW_TRACE == 1
     RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
            "Got %d args. argv[1]: %s", 
            argc, 
            RedisModule_StringPtrLen(argv[1], NULL)
      );
     RedisModule_Log(ctx ,  "warning", "suma_vip_register_list param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif
	
	RedisModuleCallReply *rep = RedisModule_Call(ctx, "SSCAN", "sccc",argv[1], "0", "COUNT", "100");
	if (REDISMODULE_REPLY_ARRAY ==  RedisModule_CallReplyType(rep)) {
		RedisModuleCallReply * vip_server_list =  RedisModule_CallReplyArrayElement( rep , 1);
		if (REDISMODULE_REPLY_ARRAY == RedisModule_CallReplyType(vip_server_list)) {
			long size_vec = RedisModule_CallReplyLength(vip_server_list);
			if (size_vec == 0) {
				RedisModule_ReplyWithLongLong(ctx, 0); // 防止挂起
				return  REDISMODULE_OK;
			}
			RedisModule_ReplyWithArray(ctx, size_vec); //begin
			for(int i = 0; i < size_vec ; i++) {
				RedisModuleCallReply * ele =  RedisModule_CallReplyArrayElement(vip_server_list , i);
				RedisModule_ReplyWithString(ctx, RedisModule_CreateStringFromCallReply(ele));
			}
			return  REDISMODULE_OK;
		}
	}
	 
	RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}
///注册vip列表
///生命周期在机器启动后注册一次
///argv[1] k , argv[2] json value
int suma_vip_register_list (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
     REDISMODULE_NOT_USED(argv);
     REDISMODULE_NOT_USED(argc);
     if (argc < 2) {
        return RedisModule_WrongArity(ctx);
     }
     
     #if ALLOW_TRACE == 1
     RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
            "Got %d args. argv[1]: %s, argv[2]: %s", 
            argc, 
            RedisModule_StringPtrLen(argv[1], NULL),
            RedisModule_StringPtrLen(argv[2], NULL)
      );
     RedisModule_Log(ctx ,  "warning", "suma_vip_register_list param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif
    
    RedisModule_AutoMemory(ctx);
 
    RedisModuleCallReply *pub_status_int = RedisModule_Call(ctx,
     "SADD", "!ss", 
     argv [1], /// vip_server key
     argv [2]);


    if (REDISMODULE_REPLY_INTEGER == RedisModule_CallReplyType(pub_status_int)) {
         long long status = RedisModule_CallReplyInteger(pub_status_int);
         if (status > 0) {
              RedisModule_ReplyWithLongLong(ctx, 1);
              return  REDISMODULE_OK;
         }
    }

    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}


// diamond list
int suma_diamond_list (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    if (argc < 2) {
        return RedisModule_WrongArity(ctx);
    }

    #if ALLOW_TRACE == 1
    RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
        "Got %d args. argv[1]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL)
    );
    RedisModule_Log(ctx ,  "warning", "suma_diamond_list param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif

    RedisModuleCallReply *rep = RedisModule_Call(ctx, "SCAN", "ccscc", "0", "MATCH", argv[1], "COUNT", "1000000");
    
    if (REDISMODULE_REPLY_ARRAY ==  RedisModule_CallReplyType(rep)) {
        /// 0 是游标 目前这里不需要
            RedisModuleCallReply * diamond_list =  RedisModule_CallReplyArrayElement( rep , 1);
            if (REDISMODULE_REPLY_ARRAY == RedisModule_CallReplyType(diamond_list)) {
                
                long size_vec = RedisModule_CallReplyLength(diamond_list);
                if (size_vec == 0) {
                    RedisModule_ReplyWithLongLong(ctx, 0); // 防止挂起
                    return  REDISMODULE_OK;
                }
                if (size_vec > 100) {
                    size_vec = 100;
                }
                RedisModule_ReplyWithArray(ctx, size_vec); //begin
                for(int i = 0; i < size_vec ; i++) {
                    RedisModuleCallReply * ele =  RedisModule_CallReplyArrayElement(diamond_list , i);
                    RedisModule_ReplyWithString(ctx, RedisModule_CreateStringFromCallReply(ele));
                }
                return  REDISMODULE_OK;
            }
    }
    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}

// diamond publish 
///argv[1] channel , argv[2] key , argv[3] value ,argv[4] diamond_list
int suma_diamond_publish (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    if (argc < 3) {
        return RedisModule_WrongArity(ctx);
    }

    #if ALLOW_TRACE == 1
    RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    RedisModule_Log(ctx ,  "warning", "suma_try_leader_string param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif

    RedisModule_AutoMemory(ctx);
    int state = 0;
    ///argv[2] stoire key, argv[3] stoire value
    RedisModuleCallReply *ret_setnx = RedisModule_Call(ctx, "SET", "!ss", argv [2], argv [3]);

    if (REDISMODULE_REPLY_STRING == RedisModule_CallReplyType(ret_setnx)) { // is string
        RedisModuleString * ret_setnx_str = RedisModule_CreateStringFromCallReply(ret_setnx);
                if (RedisModule_StringCompare (RedisModule_CreateString(ctx, "OK", 2), ret_setnx_str) == 0) {
                        state = 1;
                }
    } else{
        RedisModule_ReplyWithLongLong(ctx, 0);
        return  REDISMODULE_OK;
    }

    if (!state) { ///访问失败
        RedisModule_ReplyWithLongLong(ctx, 0);
        return  REDISMODULE_OK;
    }

    ///publish data
    RedisModuleString *scmd = RedisModule_CreateStringPrintf(ctx, 
        "{\"path\":\"%s\", \"type\":1, \"cmd\":\"diamond_config\"}", 
        RedisModule_StringPtrLen(argv[2], NULL)
    );

    #if ALLOW_TRACE == 1
         RedisModule_Log(ctx ,  "warning", "diamond_config   %s",  RedisModule_StringPtrLen(scmd, NULL));
    #endif

    RedisModuleCallReply *pub_status_int = RedisModule_Call(ctx, "PUBLISH", "ss", argv [1], scmd);

    if (REDISMODULE_REPLY_INTEGER == RedisModule_CallReplyType(pub_status_int)) {
         long long status = RedisModule_CallReplyInteger(pub_status_int);
         if (status > 0) {
              RedisModule_ReplyWithLongLong(ctx, 1);
              return  REDISMODULE_OK;
         }
    }

    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}

//TODO ..
// publish 发布消息
///argv[1] channel :, argv[2] cmd
int suma_message_publish (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {

    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    if (argc < 3) {
        return RedisModule_WrongArity(ctx);
    }

    #if ALLOW_TRACE == 1
    RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    RedisModule_Log(ctx ,  "warning", "suma_try_leader_string param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif

    RedisModule_AutoMemory(ctx);

    RedisModuleString *scmd = RedisModule_CreateStringPrintf(ctx, 
        "\"%s\"", 
        RedisModule_StringPtrLen(argv[2], NULL)
    );

    #if ALLOW_TRACE == 1
         RedisModule_Log(ctx ,  "warning", "suma_vip_publish   %s",  RedisModule_StringPtrLen(scmd, NULL));
    #endif

    RedisModuleCallReply *pub_status_int = RedisModule_Call(ctx, "PUBLISH", "ss", argv [1], scmd);

    if (REDISMODULE_REPLY_INTEGER == RedisModule_CallReplyType(pub_status_int)) {
         long long status = RedisModule_CallReplyInteger(pub_status_int);
         if (status > 0) {
              RedisModule_ReplyWithLongLong(ctx, 1);
              return  REDISMODULE_OK;
         }
    }

    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}


//恢复某个主机的vip
///argv[1] channel :, argv[2] vip_addr: vip
int suma_vip_reset (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    if (argc < 3) {
        return RedisModule_WrongArity(ctx);
    }

    #if ALLOW_TRACE == 1
    RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    RedisModule_Log(ctx ,  "warning", "suma_try_leader_string param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif
    RedisModule_AutoMemory(ctx);
    ///pub
    RedisModuleString *scmd = RedisModule_CreateStringPrintf(ctx, 
        "{\"vip\":\"%s\", \"type\":0, \"cmd\":\"reset_vip\"}", 
        RedisModule_StringPtrLen(argv[2], NULL)
    );

    #if ALLOW_TRACE == 1
         RedisModule_Log(ctx ,  "warning", "reset_vip   %s",  RedisModule_StringPtrLen(scmd, NULL));
    #endif

    RedisModuleCallReply *pub_status_int = RedisModule_Call(ctx, "PUBLISH", "ss", argv [1], scmd);

    if (REDISMODULE_REPLY_INTEGER == RedisModule_CallReplyType(pub_status_int)) {
         long long status = RedisModule_CallReplyInteger(pub_status_int);
         if (status > 0) {
              RedisModule_ReplyWithLongLong(ctx, 1);
              return  REDISMODULE_OK;
         }
    }

    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}

///摘除某个主机的vip
///argv[1] channel :, argv[2] vip_addr: vip
int suma_vip_kill (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    if (argc < 3) {
        return RedisModule_WrongArity(ctx);
    }

    #if ALLOW_TRACE == 1
    RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    RedisModule_Log(ctx ,  "warning", "suma_try_leader_string param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif
    RedisModule_AutoMemory(ctx);
    ///pub
    RedisModuleString *scmd = RedisModule_CreateStringPrintf(ctx, 
        "{\"vip\":\"%s\", \"type\":0, \"cmd\":\"kill_vip\"}", 
        RedisModule_StringPtrLen(argv[2], NULL)
    );

    #if ALLOW_TRACE == 1
         RedisModule_Log(ctx ,  "warning", "suma_vip_kill   %s",  RedisModule_StringPtrLen(scmd, NULL));
    #endif

    RedisModuleCallReply *pub_status_int = RedisModule_Call(ctx, "PUBLISH", "ss", argv [1], scmd);

    if (REDISMODULE_REPLY_INTEGER == RedisModule_CallReplyType(pub_status_int)) {
         long long status = RedisModule_CallReplyInteger(pub_status_int);
         if (status > 0) {
              RedisModule_ReplyWithLongLong(ctx, 1);
              return  REDISMODULE_OK;
         }
    }

    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}

// 选举master
// (string, string)-> int
///argv[1] master_key : owner  + bussinessid + 'master', argv[2] vip_addr: vip
int suma_try_leader_string (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    if (argc < 2) {
        return RedisModule_WrongArity(ctx);
    }
    #if ALLOW_TRACE == 1
    RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    RedisModule_Log(ctx ,  "warning", "suma_try_leader_string param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif

    RedisModule_AutoMemory(ctx);
    
    ////
    RedisModuleCallReply *ret_setnx = RedisModule_Call(ctx, "SETNX", "ss", argv [1], argv [2]);
    
    if (REDISMODULE_REPLY_INTEGER ==  RedisModule_CallReplyType(ret_setnx)) {
        ///如果没有的话设置，master 竞争完成
        long long exists_status = RedisModule_CallReplyInteger(ret_setnx);

        if (1 == exists_status) { 
             ///设置成功该主机是master 
            void  * expire_key  = RedisModule_OpenKey(ctx, argv[1], REDISMODULE_READ|REDISMODULE_WRITE) ;
            mstime_t timeout_ms = (mstime_t) TIME_OUT_NUM ; //持有锁超时
            RedisModule_SetExpire((RedisModuleKey*)expire_key,  timeout_ms); 
            RedisModule_ReplyWithLongLong(ctx, 1); //说明曾经注册过
            /////启动自动客户端
            RedisModule_Call(ctx, "sumavlib.epoll", "c", "0");
            return  REDISMODULE_OK;  
        } else {
            ///存在master
            RedisModuleCallReply *rep = RedisModule_Call(ctx, "GET", "s", argv [1]);
        
            if (REDISMODULE_REPLY_STRING == RedisModule_CallReplyType(rep)) { 
                 RedisModuleString * master_vip = RedisModule_CreateStringFromCallReply(rep);
                 if (RedisModule_StringCompare(argv[2] , master_vip) == 0) {
                    RedisModule_ReplyWithLongLong(ctx, 1); //说明曾经注册过
                    return  REDISMODULE_OK;
                 }
            } 
        }
    }
    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}

#define ALL_RETRY_LEADER_FUNC 10081
///argv[1]  owner  + bussinessid  + vip, argv[2] master_vip
//状态激活 keepalive
int suma_keep_alive_string (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    #if ALLOW_TRACE == 1
    //RedisModule_Log(ctx ,  "warning", "suma_keep_alive_string is exists");
    #endif

    if (argc < 3) {
        return RedisModule_WrongArity(ctx);
    }

    #if ALLOW_TRACE == 1
    // RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
    //     "Got %d args. argv[1]: %s, argv[2]: %s", 
    //     argc, 
    //     RedisModule_StringPtrLen(argv[1], NULL),
    //     RedisModule_StringPtrLen(argv[2], NULL)
    // );

    // RedisModule_Log(ctx ,  "warning", "suma_keep_alive_string param = %s", RedisModule_StringPtrLen(s, NULL));
	#endif

    ///强制激活
    RedisModule_AutoMemory(ctx);

    ////是否leader 
    ///针对所有的请求的master key
    RedisModuleCallReply *rep_leader_val = RedisModule_Call(ctx, "GET", "s", argv [1]);
    int is_leader =  0;
    ///目前重启后不是leader， 那么强制不是leader， 执行try leader 流程
    if (REDISMODULE_REPLY_NULL ==  RedisModule_CallReplyType(rep_leader_val)) {
        #if ALLOW_TRACE == 1
        //RedisModule_Log(ctx ,  "warning", "rep_leader_val == null");
        #endif
        RedisModule_ReplyWithLongLong(ctx, (long long) 0);
        return  REDISMODULE_OK;
    } else {
        RedisModuleString * ret_str          = RedisModule_CreateStringFromCallReply(rep_leader_val);
        is_leader =  ((RedisModule_StringCompare (ret_str , argv[2]) == 0) ? 1 : 0) ;
    }
    // #if ALLOW_TRACE == 1
    //     RedisModule_Log(ctx ,  "warning", "is_leader == %d", is_leader);
    // #endif
    ///local vip set expire 
    mstime_t timeout_ms = (mstime_t) TIME_OUT_NUM ; //持有锁超时
    void  * expire_key  = RedisModule_OpenKey(ctx, argv[2],
                                                    REDISMODULE_READ|REDISMODULE_WRITE);
    int ret_set_int = RedisModule_StringSet((RedisModuleKey*)expire_key,  argv[2]);

    if(REDISMODULE_OK == ret_set_int) {
        ///local vip set expire 
        int ret_expire_int = RedisModule_SetExpire((RedisModuleKey*)expire_key,  timeout_ms);
        if(REDISMODULE_OK == ret_expire_int) {
             //#if ALLOW_TRACE == 1
             //RedisModule_Log(ctx ,  "warning", "expire time set ok");
             //#endif
            if (0 == is_leader) { ///return master vip
                RedisModuleCallReply *master_vip       = RedisModule_Call(ctx, "GET", "s", argv [1]);
                RedisModuleString    *master_vip_value = RedisModule_CreateStringFromCallReply(master_vip);
                if(master_vip_value) {
                    RedisModule_ReplyWithString(ctx, master_vip_value);
                    return  REDISMODULE_OK;
                }
            } else { 

                    void  * master_key  = RedisModule_OpenKey(ctx, argv[1],
                                                     REDISMODULE_READ|REDISMODULE_WRITE) ;
                    ret_expire_int = RedisModule_SetExpire((RedisModuleKey*) master_key,  TIME_OUT_NUM);

                    if (REDISMODULE_OK != ret_expire_int) {
                            // #if ALLOW_TRACE == 1
                            //RedisModule_Log(ctx ,  "warning", "master key is set failed");
                            // #endif

                            RedisModule_ReplyWithLongLong(ctx, 0);
                            return  REDISMODULE_OK;
                    }
                    #if ALLOW_TRACE == 1
                          //RedisModule_Log(ctx ,  "warning", "search indexer key = %s", RedisModule_StringPtrLen(s, NULL));
                    #endif
                    ////返回list
                    RedisModuleCallReply *rep = RedisModule_Call(ctx, "SCAN", "ccscc", "0", "MATCH", argv[3], "COUNT", "1000000");
                   
                    if (REDISMODULE_REPLY_ARRAY ==  RedisModule_CallReplyType(rep)) {
                    /// 0 是游标 目前这里不需要
                        RedisModuleCallReply * vip_list =  RedisModule_CallReplyArrayElement( rep , 1);
                        if (REDISMODULE_REPLY_ARRAY == RedisModule_CallReplyType(vip_list)) {
                            
                            long size_vec = RedisModule_CallReplyLength(vip_list);
                            if (size_vec == 0) {
                                RedisModule_ReplyWithLongLong(ctx, 0); // 防止挂起
                                return  REDISMODULE_OK;
                            }
                            if (size_vec > 100) {
                                size_vec = 100;
                            }
                            RedisModule_ReplyWithArray(ctx, size_vec); //begin
                            for(int i = 0; i < size_vec ; i++) {
                                RedisModuleCallReply * ele =  RedisModule_CallReplyArrayElement( vip_list , i);
                                RedisModule_ReplyWithString(ctx, RedisModule_CreateStringFromCallReply(ele));
                            }
                            return  REDISMODULE_OK;
                        }
                }
            }
        } 
        RedisModule_ReplyWithLongLong(ctx, 0);
        return  REDISMODULE_OK;
    } else {
           #if ALLOW_TRACE == 1
             //RedisModule_Log(ctx ,  "warning", "!!suma_keep_alive_string is set failed");
          #endif
    }
    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}



///获取活跃主机状态
///argv[1]  owner  + bussinessid  + vip + '.keep', argv[2] live state
int suma_master_alive_list (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    #if ALLOW_TRACE == 1
    RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    RedisModule_Log(ctx ,  "warning", "suma_master_alive_list param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif

    if (argc < 3) {
        return RedisModule_WrongArity(ctx);
    }
    RedisModule_AutoMemory(ctx);
    // RedisModule_Log(ctx ,  "warning", "suma_master_alive_list is exists");
    RedisModuleCallReply *rep = RedisModule_Call(ctx, "SCAN", "ccscc", "0", "MATCH", argv[2], "COUNT", "1000000");
    #if ALLOW_TRACE == 1
    //RedisModule_Log(ctx ,  "warning", "rep type is %d", RedisModule_CallReplyType(rep));
    #endif
    if (REDISMODULE_REPLY_ARRAY ==  RedisModule_CallReplyType(rep)) {
        /// 0 是游标 目前这里不需要
        RedisModuleCallReply * vip_list =  RedisModule_CallReplyArrayElement( rep , 1);
       
        #if ALLOW_TRACE == 1
        //RedisModule_Log(ctx ,  "warning", "vip_list type is %d", RedisModule_CallReplyType(vip_list));
        #endif

        if (REDISMODULE_REPLY_ARRAY == RedisModule_CallReplyType(vip_list)) {
             
             long size_vec = RedisModule_CallReplyLength(vip_list);
             if (size_vec == 0) {
                RedisModule_ReplyWithLongLong(ctx, 0); // 防止挂起
                return  REDISMODULE_OK;
             }
             if (size_vec > 100) {
                 size_vec = 100;
             }
             RedisModule_ReplyWithArray(ctx, size_vec); //begin
             for(int i = 0; i < size_vec ; i++) {
                RedisModuleCallReply * ele =  RedisModule_CallReplyArrayElement( vip_list , i);
                RedisModule_ReplyWithString(ctx, RedisModule_CreateStringFromCallReply(ele));
                // RedisModule_Log(ctx ,  "warning", "rep type is %d ", RedisModule_CallReplyType(ele));
             }
             return  REDISMODULE_OK;
        }
    }
    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}


static int runable = 0;

///定时任务执行
void timerDataProcessorHandler(RedisModuleCtx *ctx, void *data) {
    REDISMODULE_NOT_USED(ctx);
    REDISMODULE_NOT_USED(data);
 
 //    RedisModuleString * snapshot_cmd =  RedisModule_CreateStringPrintf(ctx, 
 //        "local result = redis.call ('lrange', 'biz_info' , 0, -1); \
 //         redis.call('del' , 'biz_info');\
 //         local str = table.concat(result); \
 //         redis.call ('set', 'biz_info.snapshot', str); \
 //         return 1;" 
	// );

	// RedisModule_Call(ctx, "EVAL", "sc", snapshot_cmd, "0");

    /////注册
    // RedisModuleString * invoke_s =  RedisModule_CreateStringPrintf(ctx, 
    //     "local result = redis.call ('lrange', 'biz_info.list', 0, -1); \
    //      redis.log(redis.LOG_WARNING, 'range len=' .. table.getn(result)); \
    //     for i, v in ipairs (result) do \
    //         redis.log(redis.LOG_WARNING, 'range raw=' .. v); \
    //         local code = redis.call ('get' , v); \
    //         local status = register_c(v , code) ; \
    //         if status == 1 then \
    //             redis.log(redis.LOG_WARNING, 'register success'); \
    //         end\
    //     end \
    //     return 1" 
    // );
    // RedisModule_Call(ctx, "EVAL", "sc", invoke_s, "0");

    /////分析处理
    RedisModuleString * codehook =  RedisModule_CreateStringPrintf(ctx, 
        "run_c();"
    );

    RedisModule_Call(ctx, "EVAL", "sc", codehook, "0");
    #if ALLOW_TRACE == 1
      RedisModule_Log(ctx ,  "warning", "tick......");
    #endif
    RedisModule_CreateTimer(ctx, 1000, timerDataProcessorHandler, NULL);
}

///定时任务启动
int TimerCommand_RedisCommand(RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);

    if (runable == 0) {
        RedisModule_CreateTimer(ctx,1000,timerDataProcessorHandler, NULL);
        runable++;
        /////////
        ///////// 读取处理函数
        /////////
        RedisModuleString * codehook =  RedisModule_CreateStringPrintf(ctx, 
            "local result = redis.call ('lrange', 'biz_info.list', 0, -1); \
            for i, v in ipairs (result) do \
                local code = redis.call ('get' , v); \
                register_c(v , code) ; \
            end \
            return 1" 
        );
        RedisModule_Call(ctx, "EVAL", "sc", codehook, "0");
    }
    return RedisModule_ReplyWithSimpleString(ctx, "OK");
}

/***
*  数据分析函数注册
*  func_name   $1
*  func_source $2   
*/
int suma_biz_script_register (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    RedisModule_AutoMemory(ctx);
    #if ALLOW_TRACE == 1
    RedisModuleString *s = RedisModule_CreateStringPrintf(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    RedisModule_Log(ctx ,  "warning", "suma_biz_script_register param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif
    ///
    ///  获取后编译
    ///
    RedisModuleString * codehook =  RedisModule_CreateStringPrintf(ctx,  "redis.log(redis.LOG_WARNING, KEYS[1])  \n"
                                                                         "redis.log(redis.LOG_WARNING, KEYS[2])  \n"
                                                                         "return biz_compile(KEYS[1], KEYS[2]);");
    RedisModuleCallReply *rep = RedisModule_Call(ctx, "EVAL", "scss", codehook, "2" , argv[1], argv[2]);
    ///
    /// 编译完成
    ///
    RedisModule_Log(ctx ,  "warning", "suma_biz_script_register build pass");
    if (REDISMODULE_REPLY_INTEGER == RedisModule_CallReplyType(rep)) {
         long long status = RedisModule_CallReplyInteger(rep);
         if (status == 1) {
            RedisModuleString * invoke_s =  RedisModule_CreateStringPrintf(ctx, 
                "local result = redis.call ('lrange', 'biz_info.list', 0, -1); \
                for i, v in ipairs (result) do \
                    local code = redis.call ('get' , v); \
                    register_c(v , code) ; \
                end \
                return 1" 
            );
            RedisModule_Call(ctx, "EVAL", "sc", invoke_s, "0");
            RedisModule_ReplyWithLongLong(ctx, 1);
            return  REDISMODULE_OK;
         }

         if (status == 0) {
             RedisModule_Log(ctx ,  "warning", "suma_biz_script_register build pass1.1");
         }
    }
    if (REDISMODULE_REPLY_STRING == RedisModule_CallReplyType(rep)) { // is string
            RedisModuleString * ret_setnx_str = RedisModule_CreateStringFromCallReply(rep);
            if (RedisModule_StringCompare (RedisModule_CreateString(ctx, "OK", 2), ret_setnx_str) == 0) {
                RedisModule_Log(ctx ,  "warning", "suma_biz_script_register build pass2");
            } else {
                RedisModuleString * logFormat =  RedisModule_CreateStringPrintf(ctx, "%s" , 
                                                 RedisModule_StringPtrLen(ret_setnx_str, NULL));
                RedisModule_Log(ctx ,  "warning", "error: %s", RedisModule_StringPtrLen(logFormat, NULL));
            }
    } 
    RedisModule_Log(ctx ,  "warning", "suma_biz_script_register build pass3");
    RedisModule_ReplyWithLongLong(ctx, 0);
    return  REDISMODULE_OK;
}

///程序入口
int RedisModule_OnLoad(RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);

    if (RedisModule_Init(ctx, "sumavlib" , 1 ,REDISMODULE_APIVER_1) == REDISMODULE_ERR) {
        return REDISMODULE_ERR;
    } 

    if (RedisModule_CreateCommand(ctx,"sumavlib.epoll",
        TimerCommand_RedisCommand,"readonly",0,0,0) == REDISMODULE_ERR)
        return REDISMODULE_ERR;

	if (RedisModule_CreateCommand(ctx,"sumavlib.biz_script_register",  suma_biz_script_register, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }

    if (RedisModule_CreateCommand(ctx,"sumavlib.suma_try_leader",  suma_try_leader_string, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }
    
    if (RedisModule_CreateCommand(ctx,"sumavlib.suma_keep_alive",  suma_keep_alive_string, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }
    
    if (RedisModule_CreateCommand(ctx,"sumavlib.suma_vip_list",  suma_master_alive_list, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }
    
    if (RedisModule_CreateCommand(ctx,"sumavlib.suma_vip_kill",  suma_vip_kill, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }
        
    if (RedisModule_CreateCommand(ctx,"sumavlib.suma_vip_reset",  suma_vip_reset, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }

    if (RedisModule_CreateCommand(ctx,"sumavlib.suma_vip_register",  suma_vip_register_list, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }

    if (RedisModule_CreateCommand(ctx,"sumavlib.suma_message_publish",  suma_message_publish, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }

    if (RedisModule_CreateCommand(ctx,"sumavlib.suma_diamond_publish",  suma_diamond_publish, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }

    if (RedisModule_CreateCommand(ctx,"sumavlib.suma_diamond_list",  suma_diamond_list, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }
    
	if (RedisModule_CreateCommand(ctx,"sumavlib.suma_vip_server_list",  suma_vip_server_list, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }
	
	if (RedisModule_CreateCommand(ctx,"sumavlib.suma_ci_task",  suma_ci_task, "", 1, 1, 1) == REDISMODULE_ERR) {
          return REDISMODULE_ERR;
    }
	
    return REDISMODULE_OK;
}