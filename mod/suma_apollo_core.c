
/***
 * CCM1(Common Compute Module V1)  X86/X64 Linux 
 * 数码视讯 版权所有
 */


#define REDISMODULE_EXPERIMENTAL_API 1

#include <stdlib.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include "redismodule.h"
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "luajit.h"
#include "lj_arch.h"

#if LUAJIT_TARGET == LUAJIT_ARCH_X86 
#elif LUAJIT_TARGET == LUAJIT_ARCH_X64
#endif 

#define VERSION 1001
#define TIME_OUT_NUM 5000
#define REDISMODULE_REPLY_INTEGER_T long long
#define REIDSMODULE_REPLY_STAT_OK   1
#define REIDSMODULE_REPLY_STAT_FAIL 0
#define REDISMODULE_DEBUG_LEVEL1 ALLOW_TRACE == 1
#define REDISMODULE_TIME_INTERVAL 1000
#define REDISMODULE_JIT_CALL RedisModule_Call
#define REDISMODULE_SET_EXPR RedisModule_SetExpire
#define REDISMODULE_STRING_T RedisModuleString
#define REDISMODULE_STRING_ALLOC RedisModule_CreateString
#define REDISMODULE_CONTEXT_T RedisModuleCtx
#define REDISMODULE_TIMER_T  RedisModuleTimerID
#define REIDSMODULE_REPLY_STATUS_OUT RedisModule_ReplyWithLongLong
#define REDISMODULE_CREATE_THREAD_EX RedisModule_CreateTimer
#define REDISMODULE_CREATE_STRING_EX RedisModule_CreateStringPrintf
#define REDISMODULE_EVAL_T "EVAL"
#define REDISMODULE_WARN_S "warning"
#define REDISMODULE_CALL_NO_PARAM "s"
#define REDISMODULE_CALL_NO_PARAM2 "ss"
#define REIDSMODULE_DEBUG RedisModule_Log
#define REDISMODULE_AUTO_GCD RedisModule_AutoMemory
#define REDISMODULE_ERROR_CODE RedisModule_WrongArity
#define REDISMODULE_ARRAY_GET RedisModule_CallReplyArrayElement
#define REDISMODULE_INTEGER_GET RedisModule_CallReplyInteger
#define REDISMODULE_ARRAY_ALLOC RedisModule_ReplyWithArray
#define REIDSMODULE_ARRAY_LENGTH RedisModule_CallReplyLength
#define REDISMODULE_TYPE_OF_ELEMENT RedisModule_CallReplyType
#define REDISMODULE_ELE_TO_STRING RedisModule_CreateStringFromCallReply
#define REDISMODULE_ARRAY_PUSH_STR RedisModule_ReplyWithString
#define REDISMODULE_STRING_PTR_LEN RedisModule_StringPtrLen
#define REDISMODULE_ARGC_LGE_1 argc < 1
#define REDISMODULE_ARGC_LGE_2 argc < 2
#define REDISMODULE_ARGC_LGE_3 argc < 3
#define REDISMODULE_ARGC_LGE_4 argc < 4
#define REDISMODULE_EPOLL_START "sumavlib.epoll"
#define REDISMODULE_CMD_SETNEX "SETNX"
#define REDISMODULE_CMD_GET "GET"
#define REDISMODULE_CMD_SCAN "SCAN"
#define REDISMODULE_CMD_SSCAN "SSCAN"
#define REDISMODULE_CMD_MATCH "MATCH"
#define REDISMODULE_CMD_COUNT "COUNT"
#define REDISMODULE_CMD_PUBLISH "PUBLISH"
#define REDISMODULE_CMD_MATCH_NUM "1000000"
#define REDISMODULE_CMD_MATCH_FMT "ccscc"
#define ALL_RETRY_LEADER_FUNC 10081
#define REDISMODULE_STRCMP RedisModule_StringCompare
#define REDISMODULE_MESSAGE_CI_TASK   "{\"type\":1, \"cmd\":\"ci_task\"}"
#define REDISMODULE_MESSAGE_RESET_VIP "{\"vip\":\"%s\", \"type\":0, \"cmd\":\"reset_vip\"}"
#define REDISMODULE_MESSAGE_KILL_VIP  "{\"vip\":\"%s\", \"type\":0, \"cmd\":\"kill_vip\"}"
#define REDISMODULE_MESSAGE_DIAMOND_PUBLISH   "{\"path\":\"%s\", \"type\":1, \"cmd\":\"diamond_config\"}"

void set_read_obnly_copy_lua_state (lua_State *lua) ;

static lua_State * _ccm1_state;

void scriptingInit(int setup);


void ccm1_show_version(REDISMODULE_CONTEXT_T *ctx, lua_State* L) {
    int n;
    lua_getfield(L, LUA_REGISTRYINDEX, "_LOADED");
    lua_getfield(L, -1, "jit");  /* Get jit.* module table. */
    lua_remove  (L, -2);
    lua_getfield(L, -1, "status");
    lua_remove  (L, -2);
    n = lua_gettop(L);
    lua_call(L, 0, LUA_MULTRET);
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, 
    (lua_toboolean(L, n) ? "ccm1 JIT status : ON" : "ccm1 JIT status : OFF"));
}

void ccm1_call_back_server_lua (lua_State* L) {
     _ccm1_state = L;
}


static void stackDump(lua_State* L, REDISMODULE_CONTEXT_T *ctx){
    int i = 0;
    int top = lua_gettop(L);
    for (i = 1; i <= top; ++i) {
        int t = lua_type(L, i);
        switch (t) {
            case LUA_TSTRING: {
                REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, lua_tostring(L, i));
            }
            break;
            case LUA_TBOOLEAN: {
                REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, lua_toboolean(L, i) ? "true " : "false ");
            }
            break;
            case LUA_TNUMBER: {
                REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, lua_typename(L, t));
            }
            break;
            default: {
                REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, lua_typename(L, t));
            }
            break;
        }
    }
}


///获取所有vip列表 V1
int suma_ci_task (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
  REDISMODULE_NOT_USED (argv);
  REDISMODULE_NOT_USED (argc);
  REDISMODULE_AUTO_GCD (ctx); 

  RedisModuleString *scmd = REDISMODULE_CREATE_STRING_EX(ctx, REDISMODULE_MESSAGE_CI_TASK);
  #if REDISMODULE_DEBUG_LEVEL1
    REIDSMODULE_DEBUG(ctx, "warning", "suma_ci_task %s", REDISMODULE_STRING_PTR_LEN(scmd, NULL));
  #endif
  RedisModuleCallReply *pub_status_int = REDISMODULE_JIT_CALL(ctx, 
                        REDISMODULE_CMD_PUBLISH, 
                        REDISMODULE_CALL_NO_PARAM2,
                        argv[1], 
                        scmd);
  if (REDISMODULE_REPLY_INTEGER == REDISMODULE_TYPE_OF_ELEMENT(pub_status_int)) {
    REDISMODULE_REPLY_INTEGER_T status = REDISMODULE_INTEGER_GET(pub_status_int);
    if (status != REIDSMODULE_REPLY_STAT_FAIL) {
        REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
        return  REDISMODULE_OK;
    }
  }
  REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
  return  REDISMODULE_OK;
}

///获取所有vip列表 V1
int suma_vip_server_list (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);
    if (REDISMODULE_ARGC_LGE_2) {
        return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    RedisModuleString *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s", 
        argc, 
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL)
    );
    REIDSMODULE_DEBUG(ctx, "warning", "suma_vip_register_list param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    RedisModuleCallReply *rep = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_SSCAN, "sccc", argv[1], "0", "COUNT", "100");
    if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(rep)) {
        RedisModuleCallReply * vip_server_list =  REDISMODULE_ARRAY_GET(rep, 1);
        if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(vip_server_list)) {
            long size_vec = REIDSMODULE_ARRAY_LENGTH(vip_server_list);
            if (size_vec == 0) {
                REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
                return  REDISMODULE_OK;
            }
            REDISMODULE_ARRAY_ALLOC(ctx, size_vec); 
            for(int i = 0; i < size_vec; i++) {
                RedisModuleCallReply * ele = REDISMODULE_ARRAY_GET(vip_server_list , i);
                REDISMODULE_ARRAY_PUSH_STR(ctx, REDISMODULE_ELE_TO_STRING(ele));
            }
            return  REDISMODULE_OK;
        }
  }
  REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
  return  REDISMODULE_OK;
}

///vip 注册 V1
int suma_vip_register_list (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);
    if (REDISMODULE_ARGC_LGE_2) {
        return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    RedisModuleString *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL),
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx, "warning", "suma_vip_register_list param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    
 

    if (argc > 3) {
        ////集群信息
        RedisModuleString *SumaClusterInfo = REDISMODULE_CREATE_STRING_EX(ctx, "SumaClusterInfo");
        REDISMODULE_JIT_CALL(ctx, "SADD", "ss", SumaClusterInfo, argv[1]);

        RedisModuleString *lock = REDISMODULE_CREATE_STRING_EX(ctx, 
        "subtask_%s.lock", 
        REDISMODULE_STRING_PTR_LEN(argv[3], NULL));

        RedisModuleCallReply *status = REDISMODULE_JIT_CALL(ctx, "SETNX", "sc", lock, "1");
        if (REDISMODULE_REPLY_STRING == REDISMODULE_TYPE_OF_ELEMENT(status)) {
            RedisModuleString * setnx_str = REDISMODULE_ELE_TO_STRING(status);
            if (REDISMODULE_STRCMP(REDISMODULE_STRING_ALLOC(ctx, "OK", 2), setnx_str) != 0) {
                 REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
                 return  REDISMODULE_OK;
            }
        }

        RedisModuleCallReply *pub_status_int = REDISMODULE_JIT_CALL(ctx, "SADD", "ss", argv[1], argv[2]);
        if (REDISMODULE_REPLY_INTEGER == REDISMODULE_TYPE_OF_ELEMENT(pub_status_int)) {
            REDISMODULE_REPLY_INTEGER_T status = REDISMODULE_INTEGER_GET(pub_status_int);
            if(status != REIDSMODULE_REPLY_STAT_FAIL) {
                REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
                return  REDISMODULE_OK;
            }
        }

    } else {

        RedisModuleCallReply *pub_status_int = REDISMODULE_JIT_CALL(ctx, "SADD", "ss", argv[1], argv[2]);

        if (REDISMODULE_REPLY_INTEGER == REDISMODULE_TYPE_OF_ELEMENT(pub_status_int)) {
            REDISMODULE_REPLY_INTEGER_T status = REDISMODULE_INTEGER_GET(pub_status_int);
            if(status != REIDSMODULE_REPLY_STAT_FAIL) {
                REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
                return  REDISMODULE_OK;
            }
        }
        REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return  REDISMODULE_OK;
}
// diamond list
int suma_diamond_list (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);
    if (REDISMODULE_ARGC_LGE_2) {
        return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    RedisModuleString *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s", 
        argc,
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL)
    );
    REIDSMODULE_DEBUG(ctx, "warning", "suma_diamond_list param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    RedisModuleCallReply *rep = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_SCAN, "ccscc", "0", REDISMODULE_CMD_MATCH, argv[1], "COUNT", "1000000");
    if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(rep)) {
            RedisModuleCallReply * diamond_list = REDISMODULE_ARRAY_GET(rep, 1);
            if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(diamond_list)) {
                long size_vec = REIDSMODULE_ARRAY_LENGTH(diamond_list);
                if (size_vec == 0) {
                    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
                    return  REDISMODULE_OK;
                }
                if (size_vec > 100) {
                    size_vec = 100;
                }
                RedisModule_ReplyWithArray(ctx, size_vec);
                for(int i = 0; i < size_vec; i++) {
                    RedisModuleCallReply * ele = REDISMODULE_ARRAY_GET(diamond_list, i);
                    REDISMODULE_ARRAY_PUSH_STR(ctx, REDISMODULE_ELE_TO_STRING(ele));
                }
                return  REDISMODULE_OK;
            }
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
    return  REDISMODULE_OK;
}
// diamond publish V1
int suma_diamond_publish (RedisModuleCtx *ctx, RedisModuleString **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);
    if (REDISMODULE_ARGC_LGE_3) {
        return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    RedisModuleString *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL),
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx, "warning", "suma_try_leader_string param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    int state = 0;
    RedisModuleCallReply *setnx = REDISMODULE_JIT_CALL(ctx, "SET", "!ss", argv[2], argv[3]);
    if (REDISMODULE_REPLY_STRING == REDISMODULE_TYPE_OF_ELEMENT(setnx)) {
        RedisModuleString * setnx_str = REDISMODULE_ELE_TO_STRING(setnx);
        if (REDISMODULE_STRCMP(REDISMODULE_STRING_ALLOC(ctx, "OK", 2), setnx_str) == 0) {
            state = 1;
        }
    } else{
        REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
        return  REDISMODULE_OK;
    }
    if (!state) {
        REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
        return  REDISMODULE_OK;
    }
    RedisModuleString *scmd = REDISMODULE_CREATE_STRING_EX(ctx, 
        REDISMODULE_MESSAGE_DIAMOND_PUBLISH,
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    #if ALLOW_TRACE == 1
        REIDSMODULE_DEBUG(ctx, "warning", "diamond_config %s", REDISMODULE_STRING_PTR_LEN(scmd, NULL));
    #endif
    RedisModuleCallReply *pub_status_int = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_PUBLISH, "ss", argv[1], scmd);
    if (REDISMODULE_REPLY_INTEGER == REDISMODULE_TYPE_OF_ELEMENT(pub_status_int)) {
        REDISMODULE_REPLY_INTEGER_T status = REDISMODULE_INTEGER_GET(pub_status_int);
        if (status != REIDSMODULE_REPLY_STAT_FAIL) {
            REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
            return  REDISMODULE_OK;
        }
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
    return  REDISMODULE_OK;
}
// publish 发布消息 V1
int suma_message_publish (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);
    if (REDISMODULE_ARGC_LGE_3) {
        REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL); 
        return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    REDISMODULE_STRING_T *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL),
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "suma_try_leader_string param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    REDISMODULE_STRING_T *scmd = REDISMODULE_CREATE_STRING_EX(ctx, "\"%s\"", REDISMODULE_STRING_PTR_LEN(argv[2], NULL));
    #if REDISMODULE_DEBUG_LEVEL1
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "suma_vip_publish  %s",  REDISMODULE_STRING_PTR_LEN(scmd, NULL));
    #endif
    RedisModuleCallReply *pub_status_int = RedisModule_Call(ctx, REDISMODULE_CMD_PUBLISH, REDISMODULE_CALL_NO_PARAM2, argv[1], scmd);
    if (REDISMODULE_REPLY_INTEGER == RedisModule_CallReplyType(pub_status_int)) {
        REDISMODULE_REPLY_INTEGER_T status = REDISMODULE_INTEGER_GET(pub_status_int);
        if (status > 0) {
            REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
            return  REDISMODULE_OK;
        }
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return  REDISMODULE_OK;
}
//恢复某个主机的vip V1
int suma_vip_reset (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);

    if (REDISMODULE_ARGC_LGE_3) {
        REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL); 
        return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    RedisModuleString *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL),
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "suma_try_leader_string param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    RedisModuleString *scmd = REDISMODULE_CREATE_STRING_EX(ctx, 
        REDISMODULE_MESSAGE_RESET_VIP, 
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    #if REDISMODULE_DEBUG_LEVEL1
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "reset_vip =%s", REDISMODULE_STRING_PTR_LEN(scmd, NULL));
    #endif
    RedisModuleCallReply *pub_status_int = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_PUBLISH, REDISMODULE_CALL_NO_PARAM2, argv[1], scmd);
    if (REDISMODULE_REPLY_INTEGER == REDISMODULE_TYPE_OF_ELEMENT(pub_status_int)) {
        REDISMODULE_REPLY_INTEGER_T status = REDISMODULE_INTEGER_GET(pub_status_int);
        if (status > 0) {
            REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK);
            return  REDISMODULE_OK;
        }
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return  REDISMODULE_OK;
}
///摘除某个主机的vip V1
int suma_vip_kill (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);
    if (REDISMODULE_ARGC_LGE_3) {
        REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL); 
        return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    RedisModuleString *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL),
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "suma_vip_kill p= %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    RedisModuleString *scmd = REDISMODULE_CREATE_STRING_EX(ctx, 
                                        REDISMODULE_MESSAGE_KILL_VIP, 
                                        REDISMODULE_STRING_PTR_LEN(argv[2], NULL));
    #if REDISMODULE_DEBUG_LEVEL1
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "suma_vip_kill c= %s", REDISMODULE_STRING_PTR_LEN(scmd, NULL));
    #endif
    RedisModuleCallReply *pub_status_int = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_PUBLISH, REDISMODULE_CALL_NO_PARAM2, argv[1], scmd);
    if (REDISMODULE_REPLY_INTEGER == REDISMODULE_TYPE_OF_ELEMENT(pub_status_int)) {
        REDISMODULE_REPLY_INTEGER_T status = REDISMODULE_INTEGER_GET(pub_status_int);
        if (status > 0) {
            REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
            return  REDISMODULE_OK;
        }
    }
    REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL); 
    return  REDISMODULE_OK;
}
//状态激活 V1
int suma_keep_alive_string (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);
    if (REDISMODULE_ARGC_LGE_3) {
        REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL); 
        return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    REDISMODULE_STRING_T *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL),
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    REDISMODULE_NOT_USED(s);
    REIDSMODULE_DEBUG(ctx, "warning", "suma_keep_alive_string param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    RedisModuleCallReply *rep_leader_val = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_GET, REDISMODULE_CALL_NO_PARAM, argv[1]);
    int is_leader    = 0;
    void *expire_key = RedisModule_OpenKey(ctx, argv[2], REDISMODULE_READ|REDISMODULE_WRITE);
    void *master_key = RedisModule_OpenKey(ctx, argv[1], REDISMODULE_READ|REDISMODULE_WRITE);
    if (REDISMODULE_REPLY_NULL == REDISMODULE_TYPE_OF_ELEMENT(rep_leader_val)) {
        REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL); 
        return  REDISMODULE_OK;
    } else {
        REDISMODULE_STRING_T *ret_str = REDISMODULE_ELE_TO_STRING(rep_leader_val);
        is_leader = ((REDISMODULE_STRCMP(ret_str, argv[2]) == 0) ? 1 : 0);
    }
    int ret_set_int = RedisModule_StringSet((RedisModuleKey*) expire_key, argv[2]);
    if(REDISMODULE_OK == ret_set_int) {
        int ret_expire_int = REDISMODULE_SET_EXPR((RedisModuleKey*)expire_key, (mstime_t) TIME_OUT_NUM);
        if(REDISMODULE_OK == ret_expire_int) {
            if (0 == is_leader) {
                RedisModuleCallReply *master_vip       = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_GET, REDISMODULE_CALL_NO_PARAM, argv [1]);
                RedisModuleString    *master_vip_value = RedisModule_CreateStringFromCallReply(master_vip);
                if(master_vip_value) {
                    RedisModule_ReplyWithString(ctx, master_vip_value);
                    return  REDISMODULE_OK;
                }
            } else { 
                ret_expire_int = REDISMODULE_SET_EXPR((RedisModuleKey*) master_key, (mstime_t) TIME_OUT_NUM);
                if (REDISMODULE_OK != ret_expire_int) {
                    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL); 
                    return  REDISMODULE_OK;
                }
                RedisModuleCallReply *rep = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_SCAN, REDISMODULE_CMD_MATCH_FMT, 
                                                                      "0", REDISMODULE_CMD_MATCH, argv[3], REDISMODULE_CMD_COUNT, 
                                                                      REDISMODULE_CMD_MATCH_NUM);
                if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(rep)) {
                    RedisModuleCallReply *vip_list = REDISMODULE_ARRAY_GET(rep, 1);
                    if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(vip_list)) {
                        long size_vec = REIDSMODULE_ARRAY_LENGTH(vip_list);
                        if (size_vec == 0) {
                            REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
                            return  REDISMODULE_OK;
                        }
                        if (size_vec > 100) size_vec = 100;
                        REDISMODULE_ARRAY_ALLOC(ctx, size_vec);
                        for(int i = 0; i < size_vec; i++) {
                            RedisModuleCallReply * ele = REDISMODULE_ARRAY_GET(vip_list, i);
                            REDISMODULE_ARRAY_PUSH_STR(ctx, REDISMODULE_ELE_TO_STRING(ele));
                        }
                        return  REDISMODULE_OK;
                    }
                }
            }
        } 
        REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
        return  REDISMODULE_OK;
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return  REDISMODULE_OK;
}
/***
*  获取活跃leader状态  V1
*/
int suma_try_leader_string (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_AUTO_GCD(ctx);
    if (REDISMODULE_ARGC_LGE_2) {
        REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL); 
        return REDISMODULE_ERROR_CODE(ctx);
    }
    #if REDISMODULE_DEBUG_LEVEL1
    REDISMODULE_STRING_T *s = REDISMODULE_CREATE_STRING_EX(ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL),
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx , REDISMODULE_WARN_S, "suma_try_leader_string param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    RedisModuleCallReply *ret_setnx = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_SETNEX, REDISMODULE_CALL_NO_PARAM2, argv[1], argv[2]);
    if (REDISMODULE_REPLY_INTEGER ==  REDISMODULE_TYPE_OF_ELEMENT(ret_setnx)) {
        REDISMODULE_REPLY_INTEGER_T exists_status = REDISMODULE_INTEGER_GET(ret_setnx);
        if (REIDSMODULE_REPLY_STAT_OK == exists_status) {
            void * expire_key = RedisModule_OpenKey(ctx, argv[1], REDISMODULE_READ|REDISMODULE_WRITE);
            REDISMODULE_JIT_CALL (ctx, REDISMODULE_EPOLL_START, REDISMODULE_CALL_NO_PARAM, argv[1]);
            REDISMODULE_SET_EXPR ((RedisModuleKey*) expire_key, (mstime_t) TIME_OUT_NUM); 
            REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_OK);
            return  REDISMODULE_OK;
        } else {
            RedisModuleCallReply *rep = REDISMODULE_JIT_CALL(ctx, REDISMODULE_CMD_GET, REDISMODULE_CALL_NO_PARAM, argv[1]);
            if (REDISMODULE_REPLY_STRING == REDISMODULE_TYPE_OF_ELEMENT(rep)) { 
                if (REDISMODULE_STRCMP(argv[2], (REDISMODULE_STRING_T *) REDISMODULE_ELE_TO_STRING(rep)) == 0) {
                    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
                    return  REDISMODULE_OK;
                }
            } 
        }
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return  REDISMODULE_OK;
}

////
//V1.1 集群健康巡检
///
int suma_biz_id_cluster_online (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_AUTO_GCD(ctx);
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_STRING_T * check_all = REDISMODULE_CREATE_STRING_EX(ctx, "local biz_ids = redis.call ('sumavlib.suma_get_all_cluster_names', 0) ;\n"
                                                                            "if biz_ids ~= nil then                                  \n"
                                                                            "   for i, v in ipairs(biz_ids) do                       \n"
                                                                            "       local match_v     = string.sub(v, 1, string.find(v, '.vip')) .. '*.vip'\n"
                                                                            "       local biz_infos   = redis.call('scan', 0, 'MATCH', match_v, 'COUNT', '100'); \n"
                                                                            "       local message = {}\n"
                                                                            "       message.msgId= 'suma_biz_id_cluster_online'\n"
                                                                            "       message.data = v\n"
                                                                            "       message.time = redis.call('TIME')[1]\n"
                                                                            "       message.offline = (#biz_infos[2] == 0)\n"
                                                                            "       if (#biz_infos[2] == 0) then \n"
                                                                            "           local m_str = cjson.encode(message) \n"
                                                                            "           redis.call('lpush', 'subtask_operation_record', m_str)\n" /**操作记录*/
                                                                            "           redis.call('publish', 'warn_report_channel',  m_str) ; \n"           /**告警*/
                                                                            "       end\n "
                                                                            "   end\n"
                                                                            "end \n"
                                                                            "return 0 \n"
    );
    RedisModuleCallReply *_status = REDISMODULE_JIT_CALL (ctx, REDISMODULE_EVAL_T, "sc", check_all, "0");
    REDISMODULE_NOT_USED(_status);
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
    return REDISMODULE_OK;
}



////
// V1.1 获取所有集群注册的实例
////
int suma_get_all_register_instance (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_AUTO_GCD(ctx);
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    REDISMODULE_STRING_T * all_instance = REDISMODULE_CREATE_STRING_EX(ctx, "local biz_ids = redis.call ('sumavlib.suma_get_all_cluster_names', 0) ;\n"
                                                                            "local result ={} \n"
                                                                            "if biz_ids ~= nil then                                  \n"
                                                                            "   for i, v in ipairs(biz_ids) do                       \n"
                                                                            "       local biz_infos   = redis.call('sscan', tostring(v), 0); \n"
                                                                            "       if biz_infos ~= nil then\n "
                                                                            "           for d, f in ipairs(biz_infos[2]) do                                \n"
                                                                            "               result[#result+1] = f;\n"
                                                                            "           end\n"
                                                                            "       end\n"
                                                                            "   end\n"
                                                                            "end                                                     \n"
                                                                            "return result                                           \n"
    );
    RedisModuleCallReply *_status = REDISMODULE_JIT_CALL (ctx, REDISMODULE_EVAL_T, "sc", all_instance, "0");
    if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(_status)) {
            int vip_list_len = REIDSMODULE_ARRAY_LENGTH(_status);
            if (vip_list_len == 0) {
              REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
              return REDISMODULE_OK;
            }
            REDISMODULE_ARRAY_ALLOC(ctx, vip_list_len);
            int i  = 0;
            while(i < vip_list_len) {
              RedisModuleCallReply * vip_ele = REDISMODULE_ARRAY_GET(_status, i);
              REDISMODULE_ARRAY_PUSH_STR (ctx, REDISMODULE_ELE_TO_STRING(vip_ele));
              i++;
            }
            return REDISMODULE_OK;
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
    return REDISMODULE_OK;
}

////
// V1.1 获取所有集群存活的实例
////
int suma_get_all_live_instance (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_AUTO_GCD(ctx);
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    RedisModuleCallReply *resp = REDISMODULE_JIT_CALL(ctx, "SCAN", "ccccc", "0", "MATCH", "*.vip", "COUNT", "100000");
    if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(resp)) {
        RedisModuleCallReply *vip_list = REDISMODULE_ARRAY_GET(resp, 1);
        
        if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(vip_list)) {
            int vip_list_len = REIDSMODULE_ARRAY_LENGTH(vip_list);
            if (vip_list_len == 0) {
              REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
              return REDISMODULE_OK;
            }
            REDISMODULE_ARRAY_ALLOC(ctx, vip_list_len);
            int i  = 0;
            while(i < vip_list_len) {
              RedisModuleCallReply * vip_ele = REDISMODULE_ARRAY_GET(vip_list, i);
              REDISMODULE_ARRAY_PUSH_STR (ctx, REDISMODULE_ELE_TO_STRING(vip_ele));
              i++;
            }
            return REDISMODULE_OK;
        }
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return REDISMODULE_OK;
}

////
// V1.1 获取所有集群biz_id
///

int suma_get_all_cluster_names (REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_AUTO_GCD(ctx);
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);

    RedisModuleCallReply *resp = REDISMODULE_JIT_CALL(ctx, "SSCAN", "cc", "SumaClusterInfo", "0");
    if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(resp)) {
        RedisModuleCallReply *vip_list = REDISMODULE_ARRAY_GET(resp, 1);
        
        if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(vip_list)) {
            int vip_list_len = REIDSMODULE_ARRAY_LENGTH(vip_list);
            if (vip_list_len == 0) {
              REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
              return REDISMODULE_OK;
            }
            REDISMODULE_ARRAY_ALLOC(ctx, vip_list_len);
            int i  = 0;
            while(i < vip_list_len) {
              RedisModuleCallReply * vip_ele = REDISMODULE_ARRAY_GET(vip_list, i);
              REDISMODULE_ARRAY_PUSH_STR (ctx, REDISMODULE_ELE_TO_STRING(vip_ele));
              i++;
            }
            return REDISMODULE_OK;
        }
    }
    REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return REDISMODULE_OK;
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
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL),
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "suma_master_alive_list param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    RedisModuleCallReply *resp = REDISMODULE_JIT_CALL(ctx, "SCAN", "ccscc", "0", "MATCH", argv[2], "COUNT", "100000");
    if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(resp)) {
        RedisModuleCallReply *vip_list  = REDISMODULE_ARRAY_GET(resp, 1);
        
        if (REDISMODULE_REPLY_ARRAY == REDISMODULE_TYPE_OF_ELEMENT(vip_list)) {
            int vip_list_len = REIDSMODULE_ARRAY_LENGTH(vip_list);
            if (vip_list_len == 0) {
              REIDSMODULE_REPLY_STATUS_OUT(ctx, REIDSMODULE_REPLY_STAT_OK); 
              return REDISMODULE_OK;
            }
            REDISMODULE_ARRAY_ALLOC(ctx, vip_list_len);
            int i  = 0;
            while(i < vip_list_len) {
              RedisModuleCallReply * vip_ele = REDISMODULE_ARRAY_GET(vip_list, i);
              REDISMODULE_ARRAY_PUSH_STR (ctx, REDISMODULE_ELE_TO_STRING(vip_ele));
              i++;
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

    // REDISMODULE_STRING_T * snapshot_cmd = REDISMODULE_CREATE_STRING_EX(ctx, "local result = redis.call ('lrange', 'biz_info' , 0, -1) \n"
    //                                                                         "redis.call('del', 'biz_info')                            \n"
    //                                                                         "local str = table.concat(result)                         \n"
    //                                                                         "redis.call('set', 'biz_info.snapshot', str)              \n"
    // );
    // REDISMODULE_JIT_CALL(ctx, REDISMODULE_EVAL_T, "sc", snapshot_cmd, "0");
    REDISMODULE_JIT_CALL(ctx, REDISMODULE_EVAL_T, "sc", REDISMODULE_CREATE_STRING_EX(ctx, "run_c()\n"), "0");
    #if REDISMODULE_DEBUG_LEVEL1
       // REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "tick is run.");
    #endif
    REDISMODULE_TIMER_T tid = REDISMODULE_CREATE_THREAD_EX (ctx, REDISMODULE_TIME_INTERVAL, timerDataProcessorHandler, NULL);
    REDISMODULE_NOT_USED(tid);
}

/***
*  定时任务启动  V1.1
*  注册回调函数，不需要外部调用。 
*  注册内置集群是否可用巡检
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
                                                                                  "  register_c(v, code)                                        \n"
                                                                                  "end                                                          \n"
                                                                                  "return 1");
        /////V1.1 reporter for RDA(实时数据分析)

        REDISMODULE_STRING_T *warn_port_str = REDISMODULE_CREATE_STRING_EX (ctx , "local _M = {}\n"
                                                                                  "_M.process = function () \n"
                                                                                  "  redis.call('sumavlib.suma_biz_id_cluster_online',0);        \n"
                                                                                  "  redis.log(redis.LOG_WARNING, 'chk cluster reporter is run.')\n"
                                                                                  "end                                                           \n"
                                                                                  "return _M;");
        

        REDISMODULE_STRING_T *warn_port_ioc = REDISMODULE_CREATE_STRING_EX (ctx , "return redis.call ('biz_script_register', KEYS[1], KEYS[2]);");  
        RedisModuleCallReply *reporter_ioc = REDISMODULE_JIT_CALL (ctx, REDISMODULE_EVAL_T, "scsc", warn_port_ioc, "Cluster_Reporter", warn_port_str, "0");
        REDISMODULE_NOT_USED(reporter_ioc);

        /////
        REDISMODULE_NOT_USED(tid);
        STARTUP_ATOMIC_LOCK (tid);
        REDISMODULE_JIT_CALL(ctx, REDISMODULE_EVAL_T, "sc", codes_install, "0");
    }
    REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_OK);
    return REDISMODULE_OK;
}

// 数据分析函数注册  V1
int suma_biz_script_register(REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_AUTO_GCD (ctx);
    REDISMODULE_NOT_USED (argv);
    REDISMODULE_NOT_USED (argc);
    #if REDISMODULE_DEBUG_LEVEL1
    REDISMODULE_STRING_T *s = REDISMODULE_CREATE_STRING_EX (ctx, 
        "Got %d args. argv[1]: %s, argv[2]: %s", 
        argc, 
        REDISMODULE_STRING_PTR_LEN(argv[1], NULL),
        REDISMODULE_STRING_PTR_LEN(argv[2], NULL)
    );
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "suma_biz_script_register param = %s", REDISMODULE_STRING_PTR_LEN(s, NULL));
    #endif
    REDISMODULE_STRING_T *codehook = REDISMODULE_CREATE_STRING_EX(ctx, "redis.log(redis.LOG_WARNING, KEYS[1]) \n"
                                                                       "redis.log(redis.LOG_WARNING, KEYS[2]) \n"
                                                                       "biz_compile(KEYS[1], KEYS[2]);return 1\n");
    REDISMODULE_STRING_T *invoke_s = REDISMODULE_CREATE_STRING_EX(ctx, "local result = redis.call('lrange', 'biz_info.list', 0, -1) \n"
                                                                       "for i, v in ipairs (result) do        \n"
                                                                       "  local code = redis.call('get', v)   \n"
                                                                       "  register_c(v , code)                \n"
                                                                       "end                                   \n"
                                                                       "return 1");
    RedisModuleCallReply *compile_status = REDISMODULE_JIT_CALL (ctx, REDISMODULE_EVAL_T, "scss", codehook, "2", argv[1], argv[2]);
    #if REDISMODULE_DEBUG_LEVEL1
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "compile status = %d", REDISMODULE_TYPE_OF_ELEMENT(compile_status));
    #endif

    if (REDISMODULE_REPLY_INTEGER == REDISMODULE_TYPE_OF_ELEMENT(compile_status)) {
        REDISMODULE_REPLY_INTEGER_T status = REDISMODULE_INTEGER_GET(compile_status);
        if (status == REIDSMODULE_REPLY_STAT_OK) {
          RedisModuleCallReply *invoke_status = REDISMODULE_JIT_CALL(ctx, REDISMODULE_EVAL_T, "sc", invoke_s, "0");
          #if REDISMODULE_DEBUG_LEVEL1
          REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "invoke status = %d", REDISMODULE_TYPE_OF_ELEMENT(invoke_status));
          #endif

          if (REDISMODULE_REPLY_INTEGER == REDISMODULE_TYPE_OF_ELEMENT(invoke_status)) {
               if (!REDISMODULE_INTEGER_GET(invoke_status)) {
                   REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL);
                   #if REDISMODULE_DEBUG_LEVEL1
                   REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "user code compile failed1.");
                   #endif
                   return  REDISMODULE_OK;
               }
          }
          REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_OK);
          return  REDISMODULE_OK;
        } else {
            #if REDISMODULE_DEBUG_LEVEL1
            REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "user code compile failed2.");
            #endif
        }
        if (status == REIDSMODULE_REPLY_STAT_FAIL) REIDSMODULE_DEBUG(ctx, "warning", "suma_biz_script_register build failed.");
    } else {
        #if REDISMODULE_DEBUG_LEVEL1
        REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "user code compile ret type error.");
        #endif
    }
    REIDSMODULE_REPLY_STATUS_OUT (ctx, REIDSMODULE_REPLY_STAT_FAIL);
    return  REDISMODULE_OK;
}


////程序入口 V1
int RedisModule_OnLoad(REDISMODULE_CONTEXT_T *ctx, REDISMODULE_STRING_T **argv, int argc) {
    REDISMODULE_NOT_USED(argv);
    REDISMODULE_NOT_USED(argc);
    //V1.1实时分析模块
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
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_get_all_cluster_names", suma_get_all_cluster_names, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_get_all_live_instance", suma_get_all_live_instance, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_get_all_register_instance", suma_get_all_register_instance, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    if (RedisModule_CreateCommand(ctx, "sumavlib.suma_biz_id_cluster_online", suma_biz_id_cluster_online, "write deny-oom", 1, 1, 1) == REDISMODULE_ERR) return REDISMODULE_ERR;
    
    REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "SumaDrm Common Compute Module V1.1\n");

//     ///V1.2 ccm1 通用计算模块
//     lua_State *L = lua_open();  
//     if (L == NULL) {
//         REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, "ccm1 engine is not create.");
//         return REDISMODULE_OK;
//     } 
//     LUAJIT_VERSION_SYM(); 
//     lua_gc(L, LUA_GCSTOP, 0);
//     luaL_openlibs(L); 
//     lua_gc(L, LUA_GCRESTART, -1);
   

//     ccm1_show_version(ctx, L);
//     _ccm1_state = L;
//    {
//         /*** 
//         * jit版本 读取2进制文件
//         */
//         char *read_binary_file =    "function read_binary_file (f)\n"
//                                         "local file  = io.open(f, \"rb\")\n"
//                                         "if not file then\n"
//                                             "return 'file open error' \n"
//                                         "end\n"
//                                         "local bytes = file:read('*a');\n"
//                                         "file:close();\n"
//                                         "return bytes\n"
//                                     "end"; 
//         luaL_loadbuffer(L,read_binary_file, strlen(read_binary_file), "@read_binary_file_def");
//         lua_pcall(L,0,0,0);
//     }

//    {
//         /*** 
//         * jit版本 ping
//         */
//         char *ccm1_say =  "function ccm1_say ()\n"
//                            "print('ping')"
//                           "end"; 
//         luaL_loadbuffer(L,ccm1_say, strlen(ccm1_say), "@ccm1_say_def");
//         lua_pcall(L,0,0,0);
//     }


//    {
//         /*** 
//         * jit版本 启动入口
//         */
//         char *ccm1_main =  "function ccm1_main ()\n"
//                            "package.path         = package.path .. ';/home/admin/ccm1/?.lua;'"
//                            "local ccm1_engine    = require('wasm')\n"
//                            "if redis ~= ccm1_engine then return 'OK' end \n"
//                            "return 'NO'\n"
//                            "end"; 
//         luaL_loadbuffer(L,ccm1_main, strlen(ccm1_main), "@ccm1_main_def");
//         lua_pcall(L,0,0,0);
//     }

//     lua_getglobal(L, "ccm1_main");
//     lua_pcall(L,0,1,0);
    //stackDump(L, ctx);
    // REIDSMODULE_DEBUG(ctx, REDISMODULE_WARN_S, lua_tostring(L, -1));

    return REDISMODULE_OK;
}

