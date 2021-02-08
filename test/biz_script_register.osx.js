
const redis  = require("redis");

var client   = redis.createClient(require("./config.osx.js"));


console.log("register script as subtask biz");



var status = client["sumavlib.biz_script_register"]([
	"map_test",
	"local _M = {} \
	 _M.process = function () \
		redis.log(redis.LOG_WARNING, 'this is map')\
	 end\
	 return _M;\
	"
	],function(e)
{
	 console.log("sumavlib function install");
	 client.end(true);
});
