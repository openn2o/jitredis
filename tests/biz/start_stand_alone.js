
const redis  = require("redis");

var client   = redis.createClient(require("./config.js"));

client["sumavlib.epoll"](function()
{
	 console.log("sumavlib epoll is startup.");
	 client.end(true);
});