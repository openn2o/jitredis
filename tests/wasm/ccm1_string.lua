local _M = {bytes=0}

local _cache_string = {}
local _caches2 = {
    ["1048584"] = "hello2",
    ["1048591"] = "hello1"
}
_M.string_from_cstr1 = function (ptr) 
    if(_caches2["" .. ptr]) then
        return _caches2["" .. ptr];
    end
    return  _caches2["" .. ptr]; 
end

local eax = ""
_M.string_from_cstr2 = function (ptr) 
    -- if true then return "hello2"; end
    eax = ptr .. ""
    if ( _cache_string ["string_from_cstr2"] and _cache_string ["string_from_cstr2"].compiler == 0) then
        print("jit code")
        local jitcodes = {}
        jitcodes[#jitcodes+1] = "local _M = {} \n _M.m = function (e)"
        for k,v in pairs(_cache_string["string_from_cstr2"].vals) do
            jitcodes[#jitcodes+1] = "\tif e == "..k.." then return \"".. v .. '" end '
        end
        jitcodes[#jitcodes+1] = "\treturn _M.string_from_cstr2_back(e) \nend\n return _M;"
        _cache_string ["string_from_cstr2"].compiler = 1;

        local linker = load(table.concat(jitcodes, "\n"))();
        _M["string_from_cstr2_back"] = _M["string_from_cstr2"];
        _M["string_from_cstr2"] = linker.m;
        print(table.concat(jitcodes, "\n"));
        return  _M.string_from_cstr2(ptr);
    end

    local bytes = _M.bytes;
    local str = {}

    while bytes[ptr] ~= 0 do
        str[#str + 1] = string.char(bytes[ptr]);
        ptr = ptr+1;
    end

    if _cache_string["string_from_cstr2"]  == nil then
        _cache_string["string_from_cstr2"] = {
            count= 1,
            compiler= 0,
            vals = {}
        }
    end
    local val_str =  table.concat(str, "");
    _cache_string["string_from_cstr2"].vals [eax] = val_str;
    return val_str;
end
return _M;