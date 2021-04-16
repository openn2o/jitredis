/////
///  subtask 发布升级包工具
////

require("process");
const fs = require("fs");
var versionVO = null;
var pubsub_channel = null;
function useage () {
    console.log("[useage] publish [src] ");
}

if (!process.argv[2]) {
    useage();
    console.log("[warn] need src dir");
    return;
}

async function remove() {
    var distK= versionVO.BIZID + "_VERSION.hash";
    var client = (require("redis")).createClient({
        "host": versionVO.REMOTE,
        "port": 6379
    });

    client.on("error", function (err) {
        console.log("response err:" + err)
    });

    client.hdel(distK , versionVO.VERSION, function(err) {
    });
}
////发布升级包 
async function publish () {
    var distFile = "./bin.tar.gz"
    var data = fs.readFileSync(distFile).toString('base64');
    var distK= versionVO.BIZID + "_VERSION.hash";
    var client = (require("redis")).createClient({
        "host": versionVO.REMOTE,
        "port": 6379
    });

    client.on("error", function (err) {
        console.log("response err:" + err)
    });

    client.hmset(distK , versionVO.VERSION, data, function(err) {
        if(err) {
            console.log(err);
            client.end(true);
            return;
        }

        
        if (pubsub_channel) {
            var cmds = {
                "op"  : "publish.new",
                "data": versionVO
            }
            client.publish(pubsub_channel, JSON.stringify(cmds) , function (e) {
                client.end(true);
                console.log("publish done");
            })
        } else {
            ///工具模式
            client.end(true);
            console.log("publish done");
        }
        
    });

    client.on("message", function (channel, res) {
        console.log(channel, res);
    });
}

////制作压缩包
async function pack_data_packer  (dir) {
    var target_dir = process.argv[2];
    var target_path= `./bin.tar.gz`
    var spawn = require('child_process').spawn;
    var prcs  = spawn("tar", ["-zcf", target_path, "-C" ,target_dir, "."]);
    prcs.stdout.on('data', function (data) {
        console.log('标准输出：\n' + data);
    });

    prcs.stderr.on('data', function (data) {
        console.log('标准错误输出：\n' + data);
    });

    prcs.on('exit', function (code, signal) {
        console.log('子进程已退出，代码：' + code);
        publish();
    });
}

///读取文件目录
async function read_source_dir_file (path) {
    var files = [];
    const dir = await fs.promises.opendir(path);
    for await (const dirent of dir) {
        files.push(dirent.name);
    }
    console.log(files);
    version_tag_read(files);
    pack_data_packer(files);
    return files;
}

///选择版本信息JSON
async function version_tag_read(files) {
    var versionIdx = files.indexOf("VERSION");

    if (-1 == versionIdx) {
        throw new Error("not find VERSION file");
    }

    var batchIdx = files.indexOf("COMMAND");
    if (-1 == batchIdx) {
        throw new Error("not find COMMAND file");
    }
    var str_version  = fs.readFileSync(process.argv[2] + "/VERSION").toString("utf8");
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
        console.log("find pubsub channel " +  meta_version.PUBSUB);
        ///实时自动化升级
        pubsub_channel = meta_version.PUBSUB;
        ///自动作为服务
    }

    if (!meta_version.TIME) {
        meta_version.TIME = Date.now();
    }
    versionVO = meta_version;
}
////入口
function main() {
    try {
        read_source_dir_file (process.argv[2]);
    } catch (e) {
        console.log("[warn]" + process.argv[2] + " is not a dir.");
    }
    return 0;
}
main();




