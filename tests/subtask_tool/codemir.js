/////
///  subtask 本机代码更新工具
////

require("process");
var http  = require('http')
var url   = require('url')

const fs          = require("fs");
var versionVO     = null;
var u_version     = null;
var bizId         = "subtask"
var master_ip     = "10.254.12.23"; ///获取集群数据中心地址失败使用
var pubsub_channel= null;
var sys_call_fifo = [];
var service_standard = false;
function useage () {
    console.log("[useage] codemir  [version] [bizid] ");
}

if (!process.argv[2]) {
    useage();
    service_standard = true;
    console.log("[info] run it as service ");
    // return;
}

if (process.argv[3]) {
    bizId = process.argv[3];
}

if (process.argv[2]) {
    u_version = process.argv[2];
}

///读取文件目录
async function read_source_dir_file (path) {
    var files = [];
    const dir = await fs.promises.opendir(path);
    for await (const dirent of dir) {
        files.push(dirent.name);
    }
    version_tag_read(files, path);
    return files;
}

var already_sub = false;
///选择版本信息
async function version_tag_read(files, path) {
    var versionIdx = files.indexOf("VERSION");

    if (-1 == versionIdx) {
        throw new Error("not find VERSION file");
    }

    var batchIdx = files.indexOf("COMMAND");
    if (-1 == batchIdx) {
        throw new Error("not find COMMAND file");
    }
    var str_version  = fs.readFileSync(path + "/VERSION").toString("utf8");
    try {
        var meta_version = JSON.parse(str_version);
    } catch (e) {
        throw new Error("VERSION file is not JSON format");
    }
    if (!meta_version.REMOTE) {
        throw new Error("VERSION file not find remote record");
    }
    if (!meta_version.VERSION) {
        throw new Error("VERSION file not find version record ");
    }
    if (!meta_version.BIZID) {
        meta_version.BIZID = "subtask";
    }

    if (meta_version.PUBSUB) {
        console.log("[info] pubsub channel exists is " +  meta_version.PUBSUB);
        ///实时自动化升级
        pubsub_channel = meta_version.PUBSUB;
        ///自动作为服务
    }
    if (!meta_version.TIME) {
        meta_version.TIME = Date.now();
    }
    versionVO = meta_version;
    if (!pubsub_channel) {
        version_override(versionVO, path);
    } else  if(pubsub_channel && already_sub == false) {
        already_sub = true;
        client.subscribe(pubsub_channel, function (e){});
    } else {
        version_override(versionVO, path);
    }
}

///覆盖升级
function version_override (vo, path) {
    console.log("[info] the system version is begin grow up.");
    if (!vo.HOME) {
        console.log("[error] not find last version or home");
        return;
    }
    sys_call_fifo = [];
    //////backup old version
    sys_call_fifo.push(
        function () {
            try {
                console.log("[info] backup workspace " + vo.HOME);
                var spawn = require('child_process').spawn;
                var prcs  = spawn("mv", ["-f", vo.HOME , "/home/admin/backup/" + u_version]);
                prcs.stdout.on('data', function (data) {});
                prcs.stderr.on('data', function (data) {
                    console.log('[skip] ' + data);
                });
                prcs.on('error' , function (e) {
                    console.log('[skip] ' + e);
                    var f = sys_call_fifo.shift();
                    if (f != null) {
                        f();
                    }
                })
                prcs.on('exit', function (code, signal) {
                    var f = sys_call_fifo.shift();
                    if (f != null) {
                        f();
                    }
                });
            }catch (e) {
                console.log(e);
            }
        }
    )

    ////rm dist
    sys_call_fifo.push(
        function () {
            try {
                if(vo.HOME == "/") {
                    return;
                }
                console.log("[info] clear workspace " + vo.HOME);
                var spawn = require('child_process').spawn;
                var prcs  = spawn("rm", ["-rf", vo.HOME]);
                prcs.stdout.on('data', function (data) {});
                prcs.stderr.on('data', function (data) {
                    console.log('[skip] ' + data);
                });
                prcs.on('error' , function (e) {
                    console.log('[skip] ' + e);
                    var f = sys_call_fifo.shift();
                    if (f != null) {
                        f();
                    }
                })
                prcs.on('exit', function (code, signal) {
                    var f = sys_call_fifo.shift();
                    if (f != null) {
                        f();
                    }
                });
            }catch (e) {
                console.log(e);
            }
        }
    )
    ///mv new version override dist
    sys_call_fifo.push(
        function () {
            try {
                console.log("[info] override new version to " + vo.HOME);
                var spawn = require('child_process').spawn;
                var prcs  = spawn("mv", ["-f", path, vo.HOME]);
                prcs.stdout.on('data', function (data) {});
                prcs.stderr.on('data', function (data) {
                    console.log('[error] ' + data);
                });
                prcs.on('error' , function (e) {
                    console.log('[error] ' + e);
                })
                prcs.on('exit', function (code, signal) {
                    if (code == 0) {
                        var f = sys_call_fifo.shift();
                        if (f != null) {
                            f();
                        }
                    } else {
                        throw new Error("[error] system fifo call error");
                    }
                });
            }catch (e) {
                console.log(e);
            }
        }
    )

    ///change owner for nobody and grounp nobody
    sys_call_fifo.push(
        function () {
            try {
                console.log("[info] change owner for nobody and grounp nobody");
                var spawn = require('child_process').spawn;
                var prcs  = spawn("chown", ["-R", "nobody.nobody", vo.HOME]);
                prcs.stdout.on('data', function (data) {});
                prcs.stderr.on('data', function (data) {
                    console.log('[error] ' + data);
                });
                prcs.on('error' , function (e) {
                    console.log('[error] ' + e);
                })
                prcs.on('exit', function (code, signal) {
                    if (code == 0) {
                        var f = sys_call_fifo.shift();
                        if (f != null) {
                            f();
                        }
                    } else {
                        throw new Error("system fifo call error");
                    }
                });
            }catch (e) {
                console.log(e);
            }
        }
    )

    ///释放临时目录
    sys_call_fifo.push(
        function () {
            try {
                if (!path) {
                    return;
                }

                if (path.indexOf("subtask") == -1) {
                    return;
                }
                console.log("[info] release tmp dir for " + path);
                var spawn = require('child_process').spawn;
                var prcs  = spawn("rm", ["-rf", path]);
                prcs.stdout.on('data', function (data) {});
                prcs.stderr.on('data', function (data) {
                    console.log('[error] ' + data);
                });
                prcs.on('error' , function (e) {
                    console.log('[error] ' + e);
                })
                prcs.on('exit', function (code, signal) {
                    if (code == 0) {
                        var f = sys_call_fifo.shift();
                        if (f != null) {
                            f();
                        }
                    } 
                });
            }catch (e) {
                console.log(e);
            }
        }
    )

    ///exec commands restart service
    sys_call_fifo.push(
        function () {
            try {
                console.log("[info] run bash to custom commands exec.");
                var spawn = require('child_process').spawn;
                var prcs  = spawn("sh", [vo.HOME + "/COMMAND"]);
                prcs.stdout.on('data', function (data) {});
                prcs.stderr.on('data', function (data) {
                    console.log('[error] ' + data);
                });

                prcs.on('error' , function (e) {
                    console.log(e);
                })

                prcs.on('exit', function (code, signal) {
                    if (code == 0) {
                        var f = sys_call_fifo.shift();
                        if (f != null) {
                            f();
                        } else {
                            console.log(`[info] version grow up ${u_version} finished`);
                        }
                    } else {
                       console.log ("[error] system fifo call run failed");
                    }
                    console.log("[info] " + new Date() + " exit \n\n");
                });
            }catch (e) {
                console.log(e);
            }
        }
    )
    var f = sys_call_fifo.shift();
    if (f!=null) {
        f();
    }
}

///搜索该biz_id 版本
function get_version_biz_id (client, auto_close) {
    var distK= bizId + "_VERSION.hash";
    client.hmget(distK , u_version, function(err, data) {
        if(auto_close) {
            client.end(true);
        }
        if (err) {
            console.log("[error] " + err);
        }
        if (data[0]) {
            var buff = Buffer.from (data[0] , "base64");
            if (buff.byteLength > 0) {
                console.log("[info] data is get and write avaliable.");
                try {
                    var tmp = fs.mkdtempSync("subtask_tmp");

                    var dist_path = tmp + "/dist.tar.gz"
                    fs.writeFileSync(dist_path, buff);

                    var spawn = require('child_process').spawn;
                    var prcs  = spawn("tar", ["-zxvf", dist_path, "--strip-components=1", "-C" , tmp]);

                    prcs.stdout.on('data', function (data) {
                    });
                
                    prcs.stderr.on('data', function (data) {
                        console.log("[error] " + data);
                    });
                
                    prcs.on('exit', function (code, signal) {
                        if (code == 0) {
                            read_source_dir_file(tmp);
                        } else {
                            console.log("[error] tar file is fatal.");
                        }
                    });
                } catch (e) {
                    console.log("[error] write forbid error.");
                }
            } else {
                console.log("[error] get data is not bytes");
            }
        } else {
            console.log("[skip] not data in");
        }
    });
}

var client = null;
/////初始化客户端
function connect_redis_client () {
    console.log("[info] connect_redis_service is run");
    client = (require("redis")).createClient({
        "host": master_ip,
        "port": 6379
    });

    client.on("error", function (err) {
        console.log("[error] " + err)
    });
    var black_list = ["subtask", "ccm1" , "sumanri"];
    client.on("message", function (channel, res) {
        if (channel == pubsub_channel) {
            var pub_data = JSON.parse(res);
            if(!pub_data) return;
            if (pub_data.op) {
                switch (pub_data.op) {
                    case "publish.new":
                        bizId     = pub_data.data.BIZID;
                        if(black_list.indexOf(bizId) == -1) {
                            ///检查本机是否开启该biz_id服务的自动升级
                            console.log("[error] not allow other biz. ");
                            return;
                        }
                        u_version = pub_data.data.VERSION;
                        console.log("\n\n[info] " + new Date() + " entry");
                        console.log("[info] get command publish.new exec version grow");
                        console.log(`[info] recive bizId = ${bizId} version = ${u_version}`);
                        console.log('[info] recive VERSION meta ', pub_data.data);

                        if (!pub_data.data.HOME) {
                            console.log("[error] HOME path not allow null ptr.");
                            return;
                        }

                        var nc = (require("redis")).createClient({
                            "host": versionVO.REMOTE,
                            "port": 6379
                        });
                    
                        nc.on("error", function (err) {
                            console.log("response err:" + err)
                        });
                        get_version_biz_id(nc, true);
                        break;
                }
            }
        }
    });
    ///服务版本订阅升级行为
    if (service_standard) {
        ///提供监听端口给subtask守护
        u_version="1.0.0.1";
        var server = http.createServer(function (req, res){
            res.writeHead(200, {
                'Content-Type': 'text/plain;charset=utf-8'
            })
            res.write("pong");
            res.end()
        }) 
        
        server.listen(10089);
    }
    ///交互工具版本启动
    get_version_biz_id(client); 
}

////获取集群存储 ip
function select_master_ip () {
	var http    = require('http');
	var postData = "";
    var options = {
      hostname:'127.0.0.1',
      port:    8091,
      path:   '/cluster_ip',
      method: 'GET',
	  timeout:3000,
	  headers:{
		'Content-Type': 'application/json',
        'Accept':'*/*',
        'Accept-Encoding':'utf-8',
        'Accept-Language':'zh-CN,zh;q=0.8',
        'Connection':'close',
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'
		}
    };
	
	var req = http.request(options, function (res) {
        req.data = "";
        res.on('data', function (chunk) {
          if(!req.data) {
            req.data = [];
			req.size = 0;
          }
		
		  req.data.push(chunk);
		  req.size += chunk.length;
        });
		
        res.on('end', function (e) {
            var buffer = Buffer.concat(req.data, req.size);
            req.end();
            var s = buffer.toString("utf8");
            if (s) {
                master_ip = s;
                console.log("[info] find data center cluster ip " + s);
            }
            connect_redis_client();
        });
    });

    req.on('error', function (e) {
        console.log("[error] ", e);
        req.end();
        connect_redis_client();
    });
    req.write(postData);
    req.end();
}

////入口
function main() {
    select_master_ip();
    return 0;
}
main();




