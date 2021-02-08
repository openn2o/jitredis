
console.log("create some data for test");

console.log("frist create 10000+ BI logs ");

var len  = 10000;
var index= 0;
var temp = [];

for(var i = 0; i< len ; i+=7) {
	temp[i+0] = (i%2==0? "\nstart": "\nend");
	temp[i+1] = "chain" + (i%7);
	temp[i+2] = Date.now();
	temp[i+3] = "trace_id" + (i%3); 
	temp[i+4] = "biz_id"   + (i%3); 
	temp[i+5] = "127.0.0.1";
	temp[i+6] = "test?a=1&b=1";
}

console.log("upload bi data to redis.");

const redis  = require("redis");

console.log("mock suma client to flush");
var queue = [];
for(var i = 0; i< 14; i++) {


	var data = temp.slice(i * 700, i * 700 + 701);
	
	if(data && data.length > 0) {
		queue.push(data.join("\n"));
	} 
}
var client = redis.createClient(require("./config.osx.js"));

setTimeout(function fetch_next() {
	var slice = queue.shift();

	if(!slice) {
		client.end(true);
		return;	
	} 
	
	console.log(slice.length + 'bytes trans ');
	client.lpush("biz_info", slice , function(err) {
	  console.error(err);
	});
	setTimeout(fetch_next, Math.random() * 1000);
},Math.random() * 1000)




