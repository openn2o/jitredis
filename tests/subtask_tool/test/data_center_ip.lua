

---
--  获取数据中心ip
---

local cache_ngx= ngx.shared.ngx_share_dict;
local data_ip  = cache_ngx:get("cluster_data_center_ip");

if data_ip ~= nil then
	ngx.print(data_ip);
end
ngx.exit(200);

