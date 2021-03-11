local _M = {bytes=0}

local _cache_string = {}
_M.string_from_cstr = function (ptr) 
    if _cache_string [ptr] then
        return _cache_string [ptr];
    end 
    local str = {}
    local bytes = _M.bytes;
    while true do
        if bytes[ptr] == 0 then
            break;
        end
        str[#str + 1] = string.char(bytes[ptr]);
        ptr = ptr+1;
    end
    _cache_string [ptr] = table.concat(str, "");
    return _cache_string [ptr];
end

local eax = ""
_M.string_from_cstr2 = function (ptr) 
    -- if true then return "hello2"; end
    eax = ptr .. ""
    
    if _cache_string [eax] then
        _cache_string [eax].count = _cache_string [eax].count + 1;
        
        if  _cache_string [eax].count > 500 then
           
            if(_cache_string [eax].compiler == 0) then
                
                -- _M.string_from_cstr2 = function (id)
                --     return _cache_string [eax].val;
                -- end

                print("jit code")
                local jitcodes = {}
                jitcodes[#jitcodes+1] = [[function (e) \n]]
                jitcodes[#jitcodes+1] = [[goto \n]]
                jitcodes[#jitcodes+1] = [[end\n]]

                 _cache_string [eax].compiler = 1;
            end
            
        end
        return _cache_string [eax].val;
    end 
    
    local bytes = _M.bytes;
    local str = {}
    while bytes[ptr] ~= 0 do
        str[#str + 1] = bytes[ptr];
        ptr = ptr+1;
    end
    _cache_string [eax] = {
        val  = string.char(table.unpack(str)),
        count= 1,
        compiler= 0,
        vals    = ptr
    }
    return _cache_string [eax].val;
end
return _M;