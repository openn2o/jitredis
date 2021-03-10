
////监控集群告警
////测试用例


(client = (require("redis")).createClient(require("./config.js"))) ["subscribe"]([
	/* 告警专用频道 */ "warn_report_channel"
	],function(e) {
	//  client.end(true);
	console.log("告警专用服务....")
});


var message_v = {
	"suma_biz_id_cluster_online" : function (res) {
		return res.data.substring(4, res.data.indexOf("vip.list")) + " 集群不可用!";
	}
}

client.on("message", function (channel, res) {
	var cjson = JSON.parse(res);
	if (!cjson) {
		return ;
	}

	var message_gen = message_v[cjson.msgId] ;
	if (message_gen != null) {
		var readable_msg = message_gen(cjson);
		https_dingtalk_tips (readable_msg);
	} 
});

client.on("error", function (err) {
    console.log("response err:" + err)
});


function https_dingtalk_tips (val) {
	var https = require('https');
	var postData = JSON.stringify(
		{"msgtype": "text","text": {"content": "[subtask 告警] :" + val}}
	);
    var options = {
      hostname:'oapi.dingtalk.com',
      port: 443,
      path:   '/robot/send?access_token=02783526deb2b8271f119b0811d7642a1c5cbc7b1042d6b8385f26898b6f565a',
      method: 'POST',
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
	
	
	var req = https.request(options, function (res) {
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
        });
      });

      req.on('error', function (e) {
        console.error("err=:?", e);
		req.end();
      });
	  req.write(postData);
    req.end();
}
