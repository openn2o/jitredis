
(client = (require("redis")).createClient(require("./config.js"))) ["sumavlib.biz_script_register"]([
	/* 实时计算函数的名称 */ "Calc", 
	/* 实时计算函数 */
	"\n \
	 local _M = {}\n\
	 _M.process = function ()\n\
		redis.log(redis.LOG_WARNING, 'Calc')\n\
		-- 镜像获取\n\
		local data = redis.call('get',redis.BIZ_DATA);\n\
		-- 数据清洗\n\
		local data1 = split_nr(data,'\\n');\n\
		-- 链路分析\n\
		redis.log(redis.LOG_WARNING, 'data1 len =' .. #data1)\n\
		local link_d= data_ip_format (data1);\n\
		-- 存储数据\n\
		redis.log(redis.LOG_WARNING, cjson.encode(link_d));\n\
		redis.call('set','link_data',cjson.encode(link_d));\n\
	 end\n\
	 return _M;\
	"
	],function(e) {
	 console.log("sumavlib function install");
	 client.end(true);
});
