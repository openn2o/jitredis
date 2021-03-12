
local _M = {bytes=0}


_M.caches = {}

local const_char_ptr_value = function (ptr)
    local eax = ptr..""
    if _M.caches [eax] ~= nil then
        return _M.caches [eax];
    end

    local bytes = _M.bytes;
    local str = {}
    while bytes[ptr] ~= 0 do
        str[#str + 1] = string.char(bytes[ptr]);
        ptr = ptr+1;
    end
    local val = table.concat(str);
    _M.caches [eax] = val;
    return val;
end

_M.ccm1__string_from_value_to_cstr = function (ptr, size)
    return ptr;
end

_M.ccm1__string_from_cstr_to_value = function(ptr)
    return ptr;
end

_M.ccm1__log = function (str , ...) 
    str = const_char_ptr_value(str);
    print(str);
end

return _M;