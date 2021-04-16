

local _M = {}

local cjson  = require("cjson");
_M.DRM_SYSTEM_ID = {
	[ "61941095315515465232184672216011011419644" ] = function (param)
		if param.contentID ~= nil then
			if ngx.ctx.contentID == nil then
				ngx.ctx.contentID = {};
			end
			ngx.ctx.contentID[#ngx.ctx.contentID + 1] = param.contentID;
			return true;
		end
		return false
	end
}
_M.split = function (szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
	   local nFindLastIndex      = string.find(szFullString, szSeparator, nFindStartIndex)
	   if not nFindLastIndex then
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
		break
	   end
	   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
	   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
	   nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

_M.pssh_check   = function (dd)
    local obj   = ngx.decode_base64(dd);
    local byte_xor = string.byte;
	local is_m3u8  = string.char(byte_xor(obj,1,8));
    if "#EXT-X-K" == is_m3u8 then
		local test2 = _M.split(obj, ",");
		local look_up_next = false;
		for i, v in ipairs(test2) do
			if look_up_next then
				obj = ngx.decode_base64(string.sub(v, 1, #v-1));
				look_up_next = false;
			end
			if v == 'URI="data:text/plain;base64' then
				look_up_next = true;
			end
		end
	end

    local sType = string.char(byte_xor(obj,5,8)); -- Type 4字节 0x70 73 73 68
    if sType ~= "pssh" then
		return false;
	end

    local tail = #obj;
    ----因为截取的是指针，我们必须把指针转换成字符串
	local buffer = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    for i=1,16,1 do
        buffer [i] = byte_xor(obj,i+12, i+13);
    end
    local system_id = table.concat(buffer);
	-- ngx.log(ngx.ERR, "system_id1=" .. system_id);
	if _M.DRM_SYSTEM_ID[system_id] ~= nil then
		local pssh_data = string.char(byte_xor(obj,33,tail));
		local node = nil ;
		ngx.log(ngx.ERR, pssh_data)
		pcall(function ()
			node = cjson.decode(pssh_data);
		end);
		if (node ~= nil) then
			return _M.DRM_SYSTEM_ID[system_id] (node);
		end
	end
	return false;
end

_M.allowInstall = function ()
    return true;
 end

 _M.handle = function (node)
    local len = #node.contentIDs;
    for i=1, len,1 do
		_M.pssh_check(node.contentIDs[i]);
	end
end
return _M;