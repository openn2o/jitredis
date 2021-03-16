
(client = (require("redis")).createClient(require("./config.js"))) ["sumavlib.biz_script_register"]([
	/* 实时计算函数的名称 */ "Calc", 
	/* 实时计算函数 */
	`
	 local _M = {}
	 _M.process = function ()
		redis.log(redis.LOG_WARNING, 'Calc3');

		
	 end
	 return _M;
	`
	],function(e) {
	 console.log("sumavlib function install");
	 client.end(true);
});
