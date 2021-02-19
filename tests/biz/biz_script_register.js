
const redis  = require("redis");

var client   = redis.createClient(require("./config.js"));


console.log("register script as subtask biz");



var status = client["sumavlib.biz_script_register"]([
	"map_test",
	"\n \
	 local _M = {} \n\
	 _M.process = function () \n\
		redis.log(redis.LOG_WARNING, 'this is map')\n\
	 end\n\
	 return _M;\
	"
	],function(e)
{
	 console.log("sumavlib function install");
	 client.end(true);
});
