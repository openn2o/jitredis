
local _M = {bytes=0}


_M.caches = {}
_M.string_buff = {}


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

_M.ccm1__warp_from_uint8ptr_to_value= _M.ccm1__string_from_cstr_to_value;
_M.ccm1__warp_from_value_to_uint8ptr= _M.ccm1__string_from_value_to_cstr;


_M.ccm1__string_new = function (ptr) 
    return ptr;
end
_M.ccm1__string_log = function (str , ...) 
    str = const_char_ptr_value(str);
    print(str);
end


_M.ccm1__dynamic_string_new = function ()
    local ptr = table.getn(_M.string_buff);
    _M.string_buff [ptr] = {}
    return ptr;
end

_M.ccm1__dynamic_string_append = function (self,  ptr) 
    if (nil == _M.string_buff[self]) then
        error("null ptr");
        return;
    end
    local val = _M.string_buff[self]; 
    val [#val + 1] = const_char_ptr_value(ptr);
    _M.string_buff[self] = val;
    return self;
end

_M.ccm1__dynamic_string_log = function (ptr)
   
    local ptr_t = type(ptr);
    if ptr_t == "string" then
        return print(ptr);
    end

    if ptr_t == "number" then
        local refs = _M.string_buff[ptr];
        if (nil == refs) then
            return  print("ccm1__dynamic_string_log null");
        end
        print(table.concat(refs));
    end
end

_M.ccm1__dynamic_string_join = function (ptr) 
    local refs = _M.string_buff[ptr];
    if (nil == refs) then
        return  print("ccm1__dynamic_string_join null");
    end
    return (table.concat(refs));
end


return _M;