
--[[
    new RI 配置
--]]
local _M =  {
    --[[
        RI 基础设置
        owner_id 租户ID
        biz_id   业务ID
        biz_task 业务定时自检任务
        biz_limit 业务单节点限流阈值,默认为 0 不限制
        biz_ocsp_enable 业务单节点是否开启ocsp 和 crl 基础服务,可选
        biz_balck_list_enable 业务是否开启黑名单基础服务,可选
        biz_aaa_server_enable 业务是否开启AAA鉴权基础服务,可选
        biz_virify_enable 业务是否开启验签和签名基础服务, 注意必须开启
    --]]
    
    ["owner_id"] = "Suma",
    ["biz_id"]   = "Drm" ,
	--[[
		注册逻辑分布任务
	--]]
    ["biz_task"] = {
        {
			["keep_alive_uri"] = "http://127.0.0.1:8095/ping",
			["biz_id"]   = "keygateway",
			["port"]     = "8095",
		},
		{
			["keep_alive_uri"] = "http://127.0.0.1:9801/ping",
			["biz_id"]   = "basecomponet",
			["port"]     = "9801",
		}
    },
	
    ["biz_limit"] 			  = 0,
    ["biz_ocsp_enable"]       = 0,
    ["biz_ocsp_out_enable"]   = 1,
    ["biz_balck_list_enable"] = 0,
    ["biz_aaa_server_enable"] = 0,
    ["biz_verify_enable"]     = 1,
    
    --[[
        证书相关
		默认为广科院颁发测试证书
    --]]
    
	["rootca01"]    = "/data/CTA_Root_CA_Certificate_01.der",
    ["certchain01"] = "/data/CTA_DRMServer_CA_Cert.der",
    ["ricert01"]    = "/data/DEV_DRMServer_Sumavision_ComplianceTest_202010.der",
    
    --[[
        集群数据中心
    --]]
	
    ["cluster_data_center_ip"]   = "10.254.12.23",
    ["cluster_data_center_port"] = "6379",
}

	
return _M;