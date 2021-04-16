var os   = require("os");
var fs   = require("fs");
var repl = require("repl");
var user = os.userInfo();
///check uid 
if (user.gid != 0) {
    return;
}

var os_arc      = os.arch();
var os_release  = os.release();
var os_platform = os.platform();
var os_endian   = os.endianness();
var os_cpus     = os.cpus().length;
var total_mem   = ((os.totalmem() / (1024 * 1024 * 1000))>>0) + "GB";
var local_ip    = (local_ip_get() == null? "127.0.0.1": local_ip_get());
var remote_url  = null;
var display = `
欢迎使用subtask 交互式环境 ${os_arc}

Author   : agent.zy@aliyun.com 
Copy     : Sumavision Inc.
Ip       : ${local_ip} 

支持命令

.help .exit .ip .endian .cpunum .mem
.install .chinadrm
.remote_url .test
`
var help_display = `
.exit            ;;退出交互式环境
.install         ;;安装新版RI和Subtask
.test            ;;执行Subtask 测试用例
.chinadrm        ;;执行chinadrm标准符合性测试
.ip              ;;查看本机 ip
.cpunum          ;;查看本机cpu核心数量
.mem             ;;查看本机内存
.endian          ;;查看本机字节序
.set_remote_url  ;;设置远程更新代码地址
`;
console.log(display);
var replServer = repl.start({ prompt: 'subtask > ' });
replServer.displayPrompt();
replServer.defineCommand('help', {
    help: '帮助程序',
    action(name) {
      this.clearBufferedCommand();
      console.log(help_display);
      this.displayPrompt();
    }
});

var cmds_queue = [];

var need_install_dir = [
    "/home/admin/backup/",
    "/home/admin/lua/" ,
    "/home/admin/conf/",
    "/home/admin/logs/",
    "/home/admin/app/" ,
    "/home/admin/java/",
    "/home/admin/ccm1/",
    "/home/admin/tml/" ,
    "/home/admin/wasm/",
]

function local_ip_get() {
    var n_interfaces = os.networkInterfaces();
    var ips = [];
    for(var k in n_interfaces) {
        if (k == "lo") {
            continue;
        }
        var address = n_interfaces[k];
        for(var i = 0; i< address.length; i++) {
            if(address[i].family == "IPv4") {
                ips.push(address[i].address);
            }
        }
    }
    return ips.shift();
} 

function sync_mkdir_op () {
    var length  = need_install_dir.length;
    for(var i = 0; i < length; i++) {
        try {
            fs.mkdirSync(need_install_dir[i], {recursive:true});
            fs.chmodSync(need_install_dir[i], 0o777);
            console.log(`[+]${need_install_dir[i]}创建完成.`);
        } catch (e) {
            console.log(`[+]${need_install_dir[i]}跳过.`);
        }
    }
}

function sync_write_local_ip (local_ip) {
    try {
        fs.writeFileSync("/home/admin/local_ip", local_ip);
    } catch (e) {
        return 0;
    }
    return 1;
}

function sync_write_config_system_type(val) {
   try {
    fs.writeFileSync("/home/admin/conf/suma_system_type.lua", val);
   } catch (e) {
        return 0;
   }
   return 1;
}

replServer.defineCommand('set_remote_url', {
    help: '设置远程代码更新URL',
    action() {
      replServer.question(
          "请输出代码仓库ip :",
          function (ans) {
              fs.writeFileSync("/home/admin/remote", ans);
              remote_url = ans;
          }
      )
    }
  }
);


replServer.defineCommand('install', {
    help: '安装服务或者安装负载均衡',
    action() {
      replServer.question(
          "你要安装的是负载均衡系统吗?[Y/N]",
          function (ans) {

            if (!remote_url) {
                var ip = null;
                try {
                    ip = fs.readFileSync("/home/admin/remote");
                } catch (e) {
                    console.log("[-]请先执行set_remote_url设置仓库IP ");
                    return;
                }
              
                if(ip != null && ip.indexOf(".") != -1) {
                  remote_url = ip;
                } else {
                  
                }
            }
            var result = ans.toLowerCase() ;
            var os_type_code ;
            var exec_queue = [];
            sync_mkdir_op ();
            if (result == "y") {
                console.log("\n[+]开始安装负载均衡系统");
                os_type = `
                return { [type] = "loadavg" }
                `
                exec_queue.push(
                    function () {
                        const { exec } = require('child_process');
                        exec('cp -f ./loadavg.conf ./openresty/nginx/conf/nginx.conf', 
                            (error, stdout, stderr) => {
                            if (error) {
                                console.log(`[-]${error}`);
                            } else {
                                console.log(`[+]负载均衡配置写入成功`);
                            }
                            try {
                                (exec_queue.shift())();
                            }catch (e) {
                                console.log(`[+]系统调度失败`);
                            }
                        });
                    }
                );

            } else {
                console.log("\n[+]开始安装服务");
                os_type = `
                return { [type] = "webservice" }
                `

                exec_queue.push(
                    function () {
                        const { exec } = require('child_process');
                        exec('cp -f ./webservice.conf ./openresty/nginx/conf/nginx.conf', 
                            (error, stdout, stderr) => {
                            if (error) {
                                console.log(`[-]${error}`);
                            } else {
                                console.log(`[+]应用配置写入成功`);
                            }
                            try {
                                (exec_queue.shift())();
                            }catch (e) {
                                console.log(`[+]系统调度失败`);
                            }
                        });
                    }
                );
            }

            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('cp -f ./webservice.conf ./openresty/nginx/conf/nginx.conf', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]应用配置写入成功`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            if (0x1 == sync_write_config_system_type(os_type)) {
                console.log("[+]系统类型写入完成");
            } else {
                console.log("[-]系统类型写入失败");
                replServer.displayPrompt();
            }

            if (0x1 == sync_write_local_ip(local_ip)) {
                console.log("[+]本机ip写入完成");
            } else {
                console.log("[-]本机ip写入失败");
                replServer.displayPrompt();
            }

            ////////////////limits 文件描述符优化
            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('cp -f ./opt/limits.conf /etc/security/', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]limit 安装完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ////安装nginx容器
            exec_queue.push(
                function () {
                    console.log(`[+]开始安装nginx容器`);
                    const { exec } = require('child_process');
                    exec('cp -rf ./openresty /usr/local/', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]nginx容器安装完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ///更改nginx容器权限
            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('chmod 755 -R /usr/local/openresty/', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]nginx权限更新完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ///拷贝subtask配置到/home/admin/conf目录
            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('cp  -f ./subtask.conf /home/admin/conf/suma_ri_config.lua', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]subtask配置更新完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ///chmod of local service file
            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('chmod 755  ./opt/nginx.service', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]subtask开机启动权限修改完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ////开机启动安装完成
            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('cp -rf ./opt/*.service /usr/lib/systemd/system', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]subtask开机启动系统设置完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ///开机启动系统设置
            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('systemctl enable nginx.service', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]subtask开机启动安装完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('cpupower  frequency-set -g performance', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]设置系统为性能模式`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ///防火墙设置关闭
            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('systemctl disable firewalld.service', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]防火墙设置完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ///防火墙关闭
            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('service firewalld stop', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]防火墙规则关闭完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ///安装openssl
            exec_queue.push(
                function () {
                    const { exec } = require('child_process');
                    exec('cp -rf ./deps/* /lib64/', 
                        (error, stdout, stderr) => {
                        if (error) {
                            console.log(`[-]${error}`);
                        } else {
                            console.log(`[+]openssl安装完成`);
                        }
                        try {
                            (exec_queue.shift())();
                        }catch (e) {
                            console.log(`[+]系统调度失败`);
                        }
                    });
                }
            );

            ///安装Subtask Version 1.0.0.1 版本代码
            exec_queue.push(
                    function () {
                        console.log(`[+]开始安装subtask`);
                        var spawn = require('child_process').spawn;
                        var prcs  = spawn("node", ["./codemir.js", "1.0.0.1", "subtask" , remote_url]);
                        prcs.stderr.on('data', function (data) {
                            console.log('[-]'  + (data+"").replace("\\n", ""));
                            var f = exec_queue.shift();
                            if (f != null) {
                                f();
                            }
                        });
                        prcs.stdout.on('data', function (data) {
                            console.log('[+]' + (data+"").replace("\\n", ""));
                        });
                        prcs.on('error' , function (e) {
                            e = (e+"").replace("\\n", "");
                            console.log(`[-]${e}`);
                            var f = exec_queue.shift();
                            if (f != null) {
                                f();
                            }
                        })
                        prcs.on('exit', function (code, signal) {
                            var f = exec_queue.shift();
                            if (f != null) {
                                f();
                            }
                        });
                    }
                );

            try {
                (exec_queue.shift())();
            } catch (e) {
                console.log(`[+] 系统调度失败`);
            }
          }
      );
    }
});

replServer.defineCommand('ip', function saybye() {
    console.log('本机ip ：' + local_ip);
    replServer.displayPrompt();
});

replServer.defineCommand('endian', function saybye() {
    console.log('本机字节序 ：' + os_endian);
    replServer.displayPrompt();
});


replServer.defineCommand('cpunum', function saybye() {
    console.log('本机cpu核心数 ：' + os_cpus);
    replServer.displayPrompt();
});


replServer.defineCommand('mem', function saybye() {
    console.log('本机内存 ：' + total_mem);
    replServer.displayPrompt();
});


replServer.defineCommand('exit', function saybye() {
  console.log('bye.');
  this.close();
});
