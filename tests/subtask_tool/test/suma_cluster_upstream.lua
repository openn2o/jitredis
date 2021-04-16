



---防止回环
if  ngx.ctx.is_proxy_pass then
	ngx.exit(503);
	ngx.log(ngx.ERR, "net roll")
	return;
end

local upstream  = require("suma_sub_task");
upstream.proxy_subtask_pass();
