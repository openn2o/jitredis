
const redis  = require("redis");

var client   = redis.createClient(require("./config.js"));


console.log("register script as subtask biz");



var status = client["sumavlib.biz_script_register"]([
	"pppc",
	"function DDD()\n redis.log(reids.LOG_WARNING, '22') \n end"
	],function(e)
{
	 console.log("sumavlib function install");
	 client.end(true);
});
