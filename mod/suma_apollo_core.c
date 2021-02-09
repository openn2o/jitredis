
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
#define VERSION 1001
#define TIME_OUT_NUM 3000



/***
* suma_ci_task
*/
int suma_ci_task (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED   (argv);
    REDISMODULE_NOT_USED   (argc);
    RedisModule_AutoMemory (ctx);
    RedisModuleString *scmd = RedisModule_CreateStringPrintf(ctx, 
                              "{\"type\":1, \"cmd\":\"ci_task\"}");
       
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
    RedisModule_Log(ctx ,  "warning", "suma_vip_register_list param = %s", 
    RedisModule_StringPtrLen(s, NULL));
    #endif
	
	RedisModuleCallReply *rep = RedisModule_Call(ctx, "SSCAN", "sccc",argv[1], "0", "COUNT", "100");
	if (REDISMODULE_REPLY_ARRAY ==  RedisModule_CallReplyType(rep)) {
		RedisModuleCallReply * vip_server_list =  RedisModule_CallReplyArrayElement( rep , 1);
		if (REDISMODULE_REPLY_ARRAY == RedisModule_CallReplyType(vip_server_list)) {
			long size_vec = RedisModule_CallReplyLength(vip_server_list);
			if (size_vec == 0) {
				RedisModule_ReplyWithLongLong(ctx, 0); 
				return  REDISMODULE_OK;
			}
			RedisModule_ReplyWithArray(ctx, size_vec); 
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
#define REDISMODULE_REPLY_INTEGER_T long long
#define REIDSMODULE_REPLY_STAT_OK   1
#define REIDSMODULE_REPLY_STAT_FAIL 0
#define REDISMODULE_DEBUG_LEVEL1 ALLOW_TRACE == 1
#define REDISMODULE_TIME_INTERVAL 1000
#define REDISMODULE_JIT_CALL RedisModule_Call
#define REDISMODULE_STRING_T RedisModuleString
#define REDISMODULE_CONTEXT_T RedisModuleCtx
#define REDISMODULE_TIMER_T  RedisModuleTimerID
#define REIDSMODULE_REPLY_STATUS_OUT RedisModule_ReplyWithLongLong
#define REDISMODULE_CREATE_THREAD_EX RedisModule_CreateTimer
#define REDISMODULE_CREATE_STRING_EX RedisModule_CreateStringPrintf
#define REDISMODULE_EVAL_T "EVAL"
#define REDISMODULE_WARN_S "warning"
#define REDISMODULE_CALL_NO_PARAM "s"
#define REIDSMODULE_DEBUG RedisModule_Log
#define REDISMODULE_AUTO_GCD RedisModule_AutoMemory
#define REDISMODULE_ERROR_CODE RedisModule_WrongArity
#define REDISMODULE_ARRAY_GET RedisModule_CallReplyArrayElement
#define REDISMODULE_ARRAY_ALLOC RedisModule_ReplyWithArray
#define REIDSMODULE_ARRAY_LENGTH RedisModule_CallReplyLength
#define REDISMODULE_TYPE_OF_ELEMENT RedisModule_CallReplyType
#define REDISMODULE_ELE_TO_STRING RedisModule_CreateStringFromCallReply
#define REDISMODULE_ARRAY_PUSH_STR RedisModule_ReplyWithString
#define REDISMODULE_ARGC_LGE_1 argc < 1
#define REDISMODULE_ARGC_LGE_2 argc < 2
#define REDISMODULE_ARGC_LGE_3 argc < 3
#define REDISMODULE_ARGC_LGE_4 argc < 4
#define REDISMODULE_EPOLL_START "sumavlib.epoll"

// (string, string)-> int
int suma_try_leader_string (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);
    if (REDISMODULE_ARGC_LGE_2) {
        REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL); 
        return RedisModule_WrongArity(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    REDISMODULE_STRING_T *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx , REDISMODULE_WARN_S, "suma_try_leader_string param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif
    RedisModuleCallReply *ret_setnx = REDISMODULE_JIT_CALL(ctx, "SETNX", "ss", argv[1], argv[2]);
    if (REDISMODULE_REPLY_INTEGER ==  REDISMODULE_TYPE_OF_ELEMENT(ret_setnx)) {
        REDISMODULE_REPLY_INTEGER_T exists_status = RedisModule_CallReplyInteger(ret_setnx);
        if (REIDSMODULE_REPLY_STAT_OK == exists_status) { 
            void * expire_key = RedisModule_OpenKey(ctx, argv[1], REDISMODULE_READ|REDISMODULE_WRITE);
            REDISMODULE_JIT_CALL  (ctx, REDISMODULE_EPOLL_START, REDISMODULE_CALL_NO_PARAM, argv[1]);
            RedisModule_SetExpire ((RedisModuleKey*) expire_key, (mstime_t) TIME_OUT_NUM); 
            REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_OK);
            return  REDISMODULE_OK;
        } else {
            RedisModuleCallReply *rep = REDISMODULE_JIT_CALL(ctx, "GET", "s", argv [1]);
            if (REDISMODULE_REPLY_STRING == REDISMODULE_TYPE_OF_ELEMENT(rep)) { 
                if (RedisModule_StringCompare(argv[2], (REDISMODULE_STRING_T *)REDISMODULE_ELE_TO_STRING(rep)) == 0) {
                    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
                    return  REDISMODULE_OK;
                }
            } 
        }
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
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

/***
*  获取活跃主机状态  V1
*/
int suma_master_alive_list (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_AUTO_GCD(ctx);
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    if (REDISMODULE_ARGC_LGE_3) {
      REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL); 
      return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    REDISMODULE_STRING_T *s = REDISMODULE_CREATE_STRING_EX (ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "suma_master_alive_list param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif
    RedisModuleCallReply *resp = REDISMODULE_JIT_CALL(ctx, "SCAN", "ccscc", "0", "MATCH", argv[2], "COUNT", "1000000");
    if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(resp)) {
        RedisModuleCallReply *vip_list               = REDISMODULE_ARRAY_GET(resp, 1);
        REDISMODULE_REPLY_INTEGER_T i                = 0;
        if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(vip_list)) {
            REDISMODULE_REPLY_INTEGER_T vip_list_len = REIDSMODULE_ARRAY_LENGTH(vip_list);
            if (vip_list_len == 0) {
              REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL); 
              return REDISMODULE_OK;
            }
            REDISMODULE_ARRAY_ALLOC(ctx, vip_list_len);
            while(++ i <= vip_list_len) {
              RedisModuleCallReply * vip_ele = REDISMODULE_ARRAY_GET(vip_list, i);
              REDISMODULE_ARRAY_PUSH_STR (ctx, REDISMODULE_ELE_TO_STRING(vip_ele));
            }
            return REDISMODULE_OK;
        }
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return REDISMODULE_OK;
}

/***
* biz任务唯一启动标识
*/
static REDISMODULE_REPLY_INTEGER_T startup_atomic_lock = 0;
static REDISMODULE_REPLY_INTEGER_T STARTUP_ATOMIC_ISLOCK () {
    return (startup_atomic_lock == 0 ? 1 : 0);
}
static REDISMODULE_REPLY_INTEGER_T STARTUP_ATOMIC_LOCK (RedisModuleTimerID incr_id) {
    return startup_atomic_lock = incr_id;
}

/***
*  定时任务执行  V1
*  注册回调函数，不需要外部调用。 
*/
void timerDataProcessorHandler(REDISMODULE_CONTEXT_T *ctx, void *data) {
    REDISMODULE_AUTO_GCD (ctx);
    REDISMODULE_NOT_USED (data);
    REDISMODULE_STRING_T * snapshot_cmd = REDISMODULE_CREATE_STRING_EX(ctx, "local result = redis.call ('lrange', 'biz_info' , 0, -1) \n"
                                                                            "redis.call('del', 'biz_info')                            \n"
                                                                            "local str = table.concat(result)                         \n"
                                                                            "redis.call('set', 'biz_info.snapshot', str)              \n"
    );
    REDISMODULE_JIT_CALL(ctx, REDISMODULE_EVAL_T, REDISMODULE_CALL_NO_PARAM, snapshot_cmd);
    REDISMODULE_JIT_CALL(ctx, REDISMODULE_EVAL_T, REDISMODULE_CALL_NO_PARAM, REDISMODULE_CREATE_STRING_EX(ctx, "run_c()\n"));
    #if REDISMODULE_DEBUG_LEVEL1
        REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "tick is run.");
    #endif
    REDISMODULE_TIMER_T tid = REDISMODULE_CREATE_THREAD_EX (ctx, REDISMODULE_TIME_INTERVAL, timerDataProcessorHandler, NULL);
    REDISMODULE_NOT_USED(tid);
}

/***
*  定时任务启动  V1
*  注册回调函数，不需要外部调用。 
*/
int TimerCommand_RedisCommand(REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_AUTO_GCD (ctx);
    REDISMODULE_NOT_USED (argv);
    REDISMODULE_NOT_USED (argc);

    #if REDISMODULE_DEBUG_LEVEL1
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "biz engine start");
    #endif

    if (STARTUP_ATOMIC_ISLOCK()) { /*启动biz分析*/
        REDISMODULE_TIMER_T  tid            = REDISMODULE_CREATE_THREAD_EX  (ctx, REDISMODULE_TIME_INTERVAL, timerDataProcessorHandler, NULL);
        REDISMODULE_STRING_T *codes_install = REDISMODULE_CREATE_STRING_EX  (ctx, "local result = redis.call ('lrange', 'biz_info.list', 0, -1) \n"
                                                                                  "for i, v in ipairs (result) do                               \n"
                                                                                  "  local code = redis.call ('get' , v)                        \n"
                                                                                  "  register_c(v , code)                                       \n"
                                                                                  "end                                                          \n"
                                                                                  "return 1");
        REDISMODULE_NOT_USED(tid);
        STARTUP_ATOMIC_LOCK (tid);
        REDISMODULE_JIT_CALL(ctx, REDISMODULE_EVAL_T, REDISMODULE_CALL_NO_PARAM, codes_install);
    }
    REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_OK);
    return REDISMODULE_OK;
}

/***
*  数据分析函数注册  V1
*  fname   $1
*  fsource $2   
*/
int suma_biz_script_register(REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_AUTO_GCD (ctx);
    REDISMODULE_NOT_USED (argv);
    REDISMODULE_NOT_USED (argc);
    
    #if REDISMODULE_DEBUG_LEVEL1
    REDISMODULE_STRING_T *s = REDISMODULE_CREATE_STRING_EX (ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        RedisModule_StringPtrLen(argv[1], NULL),
        RedisModule_StringPtrLen(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "suma_biz_script_register param = %s", RedisModule_StringPtrLen(s, NULL));
    #endif
    REDISMODULE_STRING_T *codehook = REDISMODULE_CREATE_STRING_EX(ctx, "redis.log(redis.LOG_WARNING, KEYS[1]) \n"
                                                                       "redis.log(redis.LOG_WARNING, KEYS[2]) \n"
                                                                       "return biz_compile(KEYS[1], KEYS[2])  \n");
    REDISMODULE_STRING_T *invoke_s = REDISMODULE_CREATE_STRING_EX(ctx, "local result = redis.call('lrange', 'biz_info.list', 0, -1) \n"
                                                                       "for i, v in ipairs (result) do        \n"
                                                                       "  local code = redis.call('get', v)   \n"
                                                                       "  register_c(v , code)                \n"
                                                                       "end                                   \n"
                                                                       "return 1");

    RedisModuleCallReply *compile_status = REDISMODULE_JIT_CALL (ctx, REDISMODULE_EVAL_T, "scss", codehook, "2", argv[1], argv[2]);
    if (REDISMODULE_REPLY_INTEGER == RedisModule_CallReplyType(compile_status)) {
        REDISMODULE_REPLY_INTEGER_T status = RedisModule_CallReplyInteger(compile_status);
        if (status == REIDSMODULE_REPLY_STAT_OK) {
          REDISMODULE_JIT_CALL (ctx, REDISMODULE_EVAL_T, REDISMODULE_CALL_NO_PARAM, invoke_s);
          REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_OK);
          return  REDISMODULE_OK;
        }
        if (status == REIDSMODULE_REPLY_STAT_FAIL) REIDSMODULE_DEBUG(ctx, "warning", "suma_biz_script_register build failed.");
    }
    REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return  REDISMODULE_OK;
}



////程序入口 V1
int RedisModule_OnLoad(REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    if (RedisModule_Init         (ctx, "sumavlib"                     , 1 ,REDISMODULE_APIVER_1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.epoll"               , TimerCommand_RedisCommand,"write deny-oom", 0, 0, 0) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.biz_script_register" , suma_biz_script_register, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_try_leader"     , suma_try_leader_string,   "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_keep_alive"     , suma_keep_alive_string,   "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_vip_list"       , suma_master_alive_list,   "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_vip_kill"       , suma_vip_kill,            "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_vip_reset"      , suma_vip_reset,           "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_ci_task"        , suma_ci_task,             "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_vip_register"   , suma_vip_register_list,   "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_message_publish", suma_message_publish,     "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_diamond_publish", suma_diamond_publish,     "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_diamond_list"   , suma_diamond_list,        "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_vip_server_list", suma_vip_server_list,     "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    return REDISMODULE_OK;
}