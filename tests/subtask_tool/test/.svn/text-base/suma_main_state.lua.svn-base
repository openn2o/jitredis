--[[
授权服务系统状态热插拔的配置
--]]

return {
	--OCSP 请求
	["ocsp_option"]   = {
		["status"] = false
	},
	--签名验签
	["verify_option"] = {
		["status"] = true
	},
	--CRL 证书列表
	["crl_option"] = {
		["status"] = false,
		["url"]    = "http://192.166.64.22:9533"
	},
	--直播预取 
	["preload_option"] = {
		["status"] = false,
		["url"]    = "http://10.254.12.15:9092/ri/get/license"
	},
	--AAA授权 
	["aaa_option"] = {
		["status"] = false,
		["url"]    = "http://127.0.0.1:9531/get_rules"
	},
	-- 证书黑名单
	["blacklist_option"] = {
		["status"] = false
	}
}
