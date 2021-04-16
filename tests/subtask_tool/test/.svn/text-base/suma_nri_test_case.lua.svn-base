local _M = {}
local cjson = require("cjson");
local http  = require("resty.http"); 
local isub  = string.sub;
local ilen  = string.len;
local igsub = string.gsub;

_M.verison = "0.0.1";
_M.desc    = "newRI testcases";
local testcases = {};
---测试基础设施-生成请求体
_M.build_ri_req = function (node)
	local str_req = cjson.encode(node) 
	str_req = igsub(str_req, "%\\%/", "%/");
	
	local n_str = isub(str_req,1,ilen(str_req)-1);
	local sign  = n_str .. ",\"ocspResponse\":\"\",\"signature\":\"\"}";
	return n_str, sign;
end

---测试基础设施 请求体签名
_M.signature = function (content)
	local params = {  
	   ssl_verify = false,
	   method     = "POST"
	}
	params.headers = {};
	params.headers ["Content-Type"]  = "application/json";

	local pack = {};
	pack.source= content;
	params.body= cjson.encode(pack);
	local auth_url   = "http://127.0.0.1:9530/sign";
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	if nil ~= rres then
		return rres.body
	end
	return nil;
end


---测试基础设施 请求体签名替换
_M.sign_ri_req = function (n_str, sign) 
	if n_str == nil then 
		return nil;
	end
	if sign == nil then 
		return nil;
	end
	local sign_str = _M.signature (sign);
	
	if sign_str == nil then
	
	end
	local resp_str = n_str .. ",\"ocspResponse\":\"\",\"signature\":\"".. sign_str .."\"}";
	return resp_str;
end

_M.gen_default_ri_request = function () 
	local ReqTemplate = [[{"type":"licenseRequest","version":"2.0","deviceID":"KjKj3V1gE5GR1Psl6Vgs8rN7OqeMfH9HThALCxN6N38=","nonce":"cH0kvfO8B0gksx0CQQ8ryw==","requestTime":"1597633330","contentIDs":["aDI2NC0xMDgwLTI0ZnBzLTJNYi1zaGFuZG9uZ3R2"],"supportedAlgorithms":["KMSProfile1"],"certificateChain":["MIICGTCCAb6gAwIBAgIUAQEAAAABCyjm6n9p0j4wQc7qXFEwCgYIKoEcz1UBg3UwMjELMAkGA1UEBgwCQ04xDTALBgNVBAoMBENEVEExFDASBgNVBAMMC0RldmljZSBDQSAxMB4XDTE5MDUwNTIwMjE1N1oXDTM5MDUwNTIwMjE1N1owgY0xCzAJBgNVBAYMAkNOMQ0wCwYDVQQKDAROU1RWMSQwIgYDVQQDDBtIVy1DRFJNX1BPQ19EUk1DTElFTlRfTk9WRUwxSTBHBgNVBAUMQDJhMzJhM2RkNWQ2MDEzOTE5MWQ0ZmIyNWU5NTgyY2YyYjM3YjNhYTc4YzdjN2Y0NzRlMTAwYjBiMTM3YTM3N2YwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAATtkYZYv1C1DJZUIMQ6n/fQqmmXqFrRQxBd/7b5U7NhzzXOkaxmwuZ45CsYL3hAWzB1iSZQalNsxu6jg2THIhyMo1YwVDAOBgNVHQ8BAf8EBAMCBaAwKwYDVR0jBCQwIoAgGPwZWjPqamtiLl3Xikxbf+OAXSd8hRp8AqfGh61a8PwwFQYDVR0lAQH/BAswCQYHKoEchu8wCDAKBggqgRzPVQGDdQNJADBGAiEAku0ZrQvQLGk/R+jGuxuJN2pgbn5jheaNXV5pUiXvT9QCIQDDh2lBsJSkeJ0LRnOUVtIWFv1AZkf0dKsZBH8mbQdPaw==","MIIB0zCCAXigAwIBAgIEfAIn3zAKBggqgRzPVQGDdTAuMQswCQYDVQQGDAJDTjENMAsGA1UECgwEQ0RUQTEQMA4GA1UEAwwHUm9vdCBDQTAgFw0xOTA1MDUwNzAwMDBaGA8yMDY5MDUwNjA2NTk1OVowMjELMAkGA1UEBgwCQ04xDTALBgNVBAoMBENEVEExFDASBgNVBAMMC0RldmljZSBDQSAxMFkwEwYHKoZIzj0CAQYIKoEcz1UBgi0DQgAE3aGAtjBefYDrbO8qsg7clYH89hctgSh6fWhioYYvO8ITx8pKFDEU11kXW5VG+FSx2SvTgU7qnpkPQtplf+iMqKN+MHwwKQYDVR0OBCIEIBj8GVoz6mprYi5d14pMW3/jgF0nfIUafAKnxoetWvD8MA4GA1UdDwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMCsGA1UdIwQkMCKAIP4EoQ3dddH9RWN35Afgpwht4FTZHT/GGb/I25OUgjTRMAoGCCqBHM9VAYN1A0kAMEYCIQDJpbeu+7nk1NgMZxPmKumQjLY0Bfo/kCD1prGEQUixfgIhANKdD3dKyBv14wYHzWpLouwo3tx7N1PKBXNkD1EiGTGR"]}]]
	return  cjson.decode(ReqTemplate);
end

_M.postMan = function (body) 
	
	local params = {  
	   ssl_verify = false,
	   method     = "POST"
	}
	params.headers = {};
	params.headers ["Content-Type"]  = "application/json";
	params.body= body
	local auth_url = "http://127.0.0.1/sumadrm";
	if ngx.ctx.test ~= nil then
		auth_url   = "http://127.0.0.1/sumadrm?test=1";
	end
	
	local httpd   	 = http.new() ;
	local rres, rerr = httpd:request_uri(auth_url, params) ;
	if nil ~= rres then
		--ngx.log(ngx.ERR, rres.body);
		return rres.body
	end
	return nil;
end

local testresults = {};

--测试内容授权服务器对DRM客户端的许可证获取请求的处理功能
testcases["License 001"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		
		local node = cjson.decode(resp_data);
		
		testresults ["License 001"] = false;
		if node ~= nil then
			testresults ["License 001"] = (node.status == "success");
			ngx.log(ngx.ERR, "License 001 " .. tostring(testresults ["License 001"]));
		end
end

--测试内容授权服务器对DRM客户端的包含多个内容标识许可证请求的处理功能
testcases["License_002"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.contentIDs = {
		"aDI2NC0xMDgwLTI0ZnBzLTJNYi1zaGFuZG9uZ3R2 ",
		"aDI2NS0xMDgwLTI1ZnBzLTJNYi1zbm93"
		};
		vo.requestTime = ngx.time();
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		
		local node = cjson.decode(resp_data);
		
		testresults ["License 002"] = false;
		if node ~= nil then
			testresults ["License 002"] = (node.status == "success");
			ngx.log(ngx.ERR, "License 002 " .. tostring(testresults ["License 002"]));
		end
end

--测试内容授权服务器对客户端许可证请求中缺少数字签名的处理功能
testcases["License 003"]=  function () 
		--200
		ngx.ctx.test = nil;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n);
		local node = cjson.decode(resp_data);
		
		testresults ["License 003"] = false;
		if node ~= nil then
			testresults ["License 003"] = (node.status == "signatureError");
			ngx.log(ngx.ERR, "License 003 " .. tostring(testresults ["License 003"]));
		end
end

--测试内容授权服务器对客户端许可证请求中包含错误的数字签名的处理功能
testcases["License 004"]=  function () 
		--200
		ngx.ctx.test = nil;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = _M.sign_ri_req(n1,s1);
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		
		testresults ["License 004"] = false;
		if node ~= nil then
			testresults ["License 004"] = (node.status == "signatureError");
			ngx.log(ngx.ERR, "License 004 " .. tostring(testresults ["License 004"]));
		end
end

--测试内容授权服务器对客户端许可证请求中包含没有签名的DRM客户端CA证书的处理功能
testcases["License 005"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.certificateChain = {};
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 005"] = false;
		if node ~= nil then
			testresults ["License 005"] = (node.status == "Illegal Argument");
			ngx.log(ngx.ERR, "License 005 " .. tostring(testresults ["License 005"]));
		end
end

--测试内容授权服务器对客户端许可证请求中包含没有签名的DRM客户端CA证书的处理功能
testcases["License 006"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.certificateChain = {
		"1111",
		"2222"
		};
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 006"] = false;
		if node ~= nil then
			testresults ["License 006"] = (node.status == "cekinfo empty");
			ngx.log(ngx.ERR, "License 006 " .. tostring(testresults ["License 006"]));
		end
end


--测试内容授权服务器对客户端许可证请求中缺少协议版本参数的处理
testcases["License 014"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.version = nil;
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 014"] = false;
		if node ~= nil then
			testresults ["License 014"] = (node.status == "versionNotSupported");
			ngx.log(ngx.ERR, "License 014 " .. tostring(testresults ["License 014"]));
		end
end

--测试内容授权服务器对客户端所使用的协议版本请求不支持的处理功能
testcases["License 015"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.version = "3.0";
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 015"] = false;
		if node ~= nil then
			testresults ["License 015"] = (node.status == "versionNotSupported");
			ngx.log(ngx.ERR, "License 015 " .. tostring(testresults ["License 015"]));
		end
end

--测试内容授权服务器对客户端许可证请求中缺少请求时间参数的处理
testcases["License 016"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = nil;
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 016"] = false;
		if node ~= nil then
			testresults ["License 016"] = (node.status == "deviceTimeError");
			ngx.log(ngx.ERR, "License 016 " .. tostring(testresults ["License 016"]));
		end
end

--测试内容授权服务器对客户端许可证请求中DRM客户端时间错误的处理功能
testcases["License 017"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = 0;
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 017"] = false;
		if node ~= nil then
			testresults ["License 017"] = (node.status == "deviceTimeError");
			ngx.log(ngx.ERR, "License 017 " .. tostring(testresults ["License 017"]));
		end
end

--测试内容授权服务器对客户端许可证请求中缺少客户端随机数参数的处理

testcases["License 018"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.nonce = nil;
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		ngx.log(ngx.ERR , resp_data);
		testresults ["License 018"] = false;
		if node ~= nil then
			testresults ["License 018"] = (node.status == "abort");
			ngx.log(ngx.ERR, "License 018 " .. tostring(testresults ["License 018"]));
		end
end

--测试内容授权服务器对客户端许可证每次请求中包含客户端随机数每次不一样的处理

testcases["License 019"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.nonce = "alert_exists_id";
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 019"] = false;
		if node ~= nil then
			testresults ["License 019"] = (node.status == "abort");
			ngx.log(ngx.ERR, "License 019 " .. tostring(testresults ["License 019"]));
		end
end

--测试内容授权服务器对客户端许可证请求中缺少支持算法参数的处理

testcases["License 020"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.selectedAlgorithm = nil;
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 020"] = false;
		if node ~= nil then
			testresults ["License 020"] = (node.status == "abort");
			ngx.log(ngx.ERR, "License 020 " .. tostring(testresults ["License 020"]));
		end
end

-- 测试内容授权服务器对客户端许可证请求中包含错误的支持算法参数的处理
testcases["License 021"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.selectedAlgorithm = "CENC-AES_128"
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 021"] = false;
		if node ~= nil then
			testresults ["License 021"] = (node.status == "abort");
			ngx.log(ngx.ERR, "License 021 " .. tostring(testresults ["License 021"]));
		end
end


--测试内容授权服务器对客户端许可证请求中缺少客户端标识参数的处理
testcases["License 022"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.deviceID  = nil;
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		--ngx.log(ngx.ERR , resp_data);
		testresults ["License 022"] = false;
		if node ~= nil then
			testresults ["License 022"] = (node.status == "abort");
			ngx.log(ngx.ERR, "License 022 " .. tostring(testresults ["License 022"]));
		end
end

--测试内容授权服务器对客户端许可证请求中包含错误的客户端标识参数的处理
testcases["License 023"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.deviceID  = "CCCC";
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		ngx.log(ngx.ERR , resp_data);
		testresults ["License 023"] = false;
		if node ~= nil then
			testresults ["License 023"] = (node.status ~= "success");
			ngx.log(ngx.ERR, "License 023 " .. tostring(testresults ["License 023"]));
		end
end
--测试内容授权服务器对客户端许可证请求中缺少内容标识参数的处理
testcases["License 025"]=  function () 
		--200
		ngx.ctx.test = true;
		local vo = _M.gen_default_ri_request();
		vo.requestTime = ngx.time();
		vo.contentIDs  = nil;
		local n1, s1 = _M.build_ri_req(vo);
		local resp_n = s1;
		local resp_data = _M.postMan(resp_n)
		local node = cjson.decode(resp_data);
		ngx.log(ngx.ERR , resp_data);
		testresults ["License 025"] = false;
		if node ~= nil then
			testresults ["License 025"] = (node.status == "contentIDNotFound");
			ngx.log(ngx.ERR, "License 025 " .. tostring(testresults ["License 025"]));
		end
end



_M.handle = function ()
	
	--testcases ["License_002"]();
	--testcases ["License 003"]();
	--testcases ["License 004"]();
	--testcases ["License 005"]();
	--testcases ["License 006"]();
	--testcases ["License 014"]();
	--testcases ["License 015"]();
	--testcases ["License 016"]();
	--testcases ["License 017"]();
	--testcases ["License 018"]();
	--testcases ["License 019"]();
	--testcases ["License 020"]();
	--testcases ["License 021"]();
	--testcases ["License 022"]();
	--testcases ["License 023"]();
	--testcases ["License 025"]();
	
	
	local step = 1;
	while step < 33 do
		local idx = step;
		if step < 10 then
			idx = "0" .. idx;
		end
		local k = 'License 0' .. idx;
		
		if testcases[k] == nil then
			testresults [k] = false;
		else
			testcases [k]();
		end
		if testresults [k] then
			ngx.print(k .. "=> pass \n" );
		else
			ngx.print(k .. "=> failed \n" );
		end
		step = step+1;
	end
	ngx.exit(200);
end
testcases ["License 001"]();
--_M.handle ();
