
----
---- 通用计算模块(CCM) v1.0
----
local WASM_VERSION_MAGIC     = "\x00\x61\x73\x6D\x01\x00\x00\x00"
local WASM_VERSION_MAGIC_LEN = #WASM_VERSION_MAGIC

local jit = require("jit");
local bit = require("bit");
local ffi = require("ffi");

if jit.status() == nil then
  print("not support this platform!");
  print("not support jit.");
  return 0;
end

local opcodes  = require("opcodes")
local compiler = require("compiler")

local function nibble(stream)
    return stream:sub(1, 1), stream:sub(2)
end

local parseLEBu = function (stream, nBytes)
    local result, byte = 0
    local bitCnt = nBytes * 7
    for shift = 0, bitCnt,  7 do
      byte, stream = stream:sub(1, 1):byte(), stream:sub(2)
      if byte == nil then
        return 1 , stream;  
      end
      result = bit.bor(result, bit.lshift(bit.band(byte, 0x7F), shift))
      if bit.band(byte, 0x80) == 0 then
        break
      end
    end
  
    return result, stream
end

function parseVLString(stream)
    local stringLen
    stringLen, stream = parseLEBu(stream, 4)
    return stream:sub(1, stringLen), stream:sub(stringLen + 1)
end

local types = {
    [0x7f] = 1, -- i32
    [0x7e] = 2, -- i64
    [0x7d] = 3, -- f32
    [0x7c] = 4, -- f64
    [0x70] = 5, -- anyfunc
    [0x60] = 6, -- func
    [0x40] = 7  -- psuedo 'empty_block' type
} 

local kinds = {
    Function = 0,
    Table = 1,
    Memory = 2,
    Global = 3
  }
  
  local typeMap = {
    NONE = 0,
    I32  = 1,
    I64  = 2,
    F32  = 3,
    F64  = 4,
    BLOC = 7,
    VUI1 = 10,
    VUI3 = 11,
    VUI6 = 12,
    VSI3 = 13,
    VSI6 = 14,
    VF32 = 15,
    VF64 = 16,
    BRTB = 17,
    CALI = 18,
    MEMI = 19
  }

  
function  parseLEBs(stream, nBytes)
    local result, byte = 0
    local bitCnt = nBytes * 7
    local bitMask = 0
    for shift = 0, bitCnt, 7 do
      bitMask = bit.lshift(bitMask, 7) + 0x7F
      byte, stream = stream:sub(1, 1):byte(), stream:sub(2)
      result = bit.bor(result, bit.lshift(bit.band(byte, 0x7F), shift))
      if bit.band(byte, 0x80) == 0 then
        -- Perform signing
        if bit.band(bit.rshift(result, shift), 0x40) ~= 0 then
          result = -bit.band(bit.bnot(result) + 1, bitMask)
        end
  
        break
      end
    end
  
    return result, stream
  end

  
function  parseFloat(stream, bytes)
    local floatArr = ffi.new("uint8_t[" .. bytes .. "]")

    local byteStr
    byteStr, stream = stream:sub(1, bytes), stream:sub(bytes + 1)

    for i = 1, #byteStr do
    floatArr[i - 1] = byteStr:byte(i)
    end

    local floatPtr
    if bytes == 4 then
    floatPtr = ffi.cast("float*", floatArr)
    elseif bytes == 8 then
    floatPtr = ffi.cast("double*", floatArr)
    else
    error("Invalid floating point type '" .. bytes .. "'", 0)
    end
    return floatPtr[0], stream
 end
  
 local  _M ={
   ["br_tables"] = {}
 }
  local function decodeImmediate(type, stream, stacks_imm)
    local result
    local count
    if type == typeMap.VUI1 then
      result, stream =  parseLEBu(stream, 1)
    elseif type == typeMap.VUI3 then
      result, stream =  parseLEBu(stream, 4)
    elseif type == typeMap.VSI3 then
      result, stream =  parseLEBs(stream, 4)
    elseif type == typeMap.VSI6 then
      result, stream =  parseLEBs(stream, 8)
    elseif type == typeMap.VF64 then
      result, stream =  parseFloat(stream, 8)
    elseif type == typeMap.VF32 then
      result, stream =  parseFloat(stream, 4)
    elseif type == typeMap.BLOC then
      result, stream =  parseLEBs(stream, 1)
    elseif type == typeMap.MEMI then
      -- We don't (currently) care about the alignment or the offset
      _, stream = parseLEBu(stream, 1)
      _, stream = parseLEBu(stream, 1)
    elseif type == typeMap.BRTB then
      count, stream = parseLEBu(stream, 32);
      local i = 1;
      local ctl ;
      local depth;
      local br_tables_local = {}
      br_tables_local.br_tables = {}
      while  i <= count do
        ctl, stream = parseLEBu(stream, 32);
        br_tables_local.br_tables[i] = ctl;
        i = i+1;
      end
      depth, stream = parseLEBu(stream, 32); -- depth
      br_tables_local.brtable_stack_depth = depth + 1;
      br_tables_local.brtable_stack = {}
      return result, stream, br_tables_local
    elseif type == typeMap.CALI then
      print("CALI caught..")
      result, stream = parseLEBu(stream, 1)
      result, stream = parseLEBu(stream, 32)
    else
      error("Unsupported immediate type required: '" .. type .. "'", 0)
    end
    return result, stream
  end
  
  local function decodeFunctionBody(stream)
    local body = {}
    local hasTableV  = false;
    while #stream > 1 do
      local opcode
      opcode, stream = nibble(stream)
      opcode = opcode:byte()
      local opcodeDef = opcodes.codes[opcode]
      if not opcodeDef then
        error(("Unsupported opcode: '%x'"):format(opcode), 0)
      end
      local instr = {
        name = opcodeDef.textName,
        enum = opcodeDef.enumName,
        proto = opcodeDef
      }
      local immediate = opcodeDef.immediate
      local brtableVal = nil;
      if immediate ~= typeMap.NONE then
        instr.imVal, stream, brtableVal = decodeImmediate(immediate, stream, body)
        if brtableVal ~= nil then
          instr.br_table = brtableVal;
          hasTableV      = brtableVal;
          -- print(".................." , instr.name)
        end
      end
      -- print("decodeFunctionBody= " , tostring(brtableVal))
      body[#body + 1] = instr
    end
    if stream:byte() == nil then
      print('error')
    end
    --print(stream:byte(), opcodes.enum.End.opcode)
    if stream:byte() ~= opcodes.enum.End.opcode then
      print("Function declaration did not end with 'End' opcode", 0)
    end
    if hasTableV then
      return body, hasTableV;
    end
    return body
  end
  local function parseInitializerExpr(stream)
    local opcode
    opcode, stream = nibble(stream)
    opcode = opcode:byte()

    local def = opcodes.codes[opcode]
    local initType = def.immediate
    local initVal
    local brtables
    initVal, stream, brtables = decodeImmediate(initType, stream)
    -- print("decodeImmedidate" , tostring(brtables))
    local endByte
    endByte, stream = nibble(stream)
    if endByte:byte() ~= opcodes.enum.End.opcode then
      -- print(endByte:byte(), opcodes.enum.End.opcode)
      error("getGlobal initializer expression NYI", 0)
    end
  
    return initVal, stream, brtables
  end


local sections = {
    [1] = function(stream) -- Types section
      local count
      count, stream =  parseLEBu(stream, 4)
  
      local typeDeclarations = {}
      
      for i = 1, count do
        local typeKind
        typeKind, stream = nibble(stream)
        typeKind = typeKind:byte()
  
        if types[typeKind] == 6 then -- Function Type
          local funcType = {
            params = {},
            returns = {}
          }
  
          -- Parse in the parameter types
          local paramCount
          paramCount, stream = nibble(stream)
          paramCount = parseLEBu(paramCount, 4)
  
          for j = 1, paramCount do
            local paramType
            paramType, stream = nibble(stream)
            paramType = paramType:byte()
            funcType.params[j] = types[paramType]
          end
  
          -- Parse in the return types
          local returnCount
          returnCount, stream = nibble(stream)
          returnCount = parseLEBu(returnCount, 4)
  
          for j = 1, returnCount do
            local returnType
            returnType, stream = nibble(stream)
            returnType = returnType:byte()
            funcType.returns[j] = types[returnType]
          end
  
          typeDeclarations[i - 1] = funcType
        else
          error("Unsupported type declaration '" .. typeKind .. "'", 0)
        end
      end
  
      return typeDeclarations
    end,
    [2] = function(stream) -- Imports Section
      local count
      count, stream = parseLEBu(stream, 4)
  
      local imports = {}
  
      for i = 1, count do
        local import = {}
  
        import.module, stream = parseVLString(stream)
        import.field, stream =  parseVLString(stream)
        import.kind, stream = nibble(stream)
        import.kind = import.kind:byte()
  
        if import.kind == kinds.Function then
          import.typeIndex, stream = parseLEBu(stream, 4)
        else
          if import.kind == 0x03 then
            error("Unsupported import kind caught..")
            --[[
            0000011: 03           ; import.kind
            0000012: 656e 76      env; import module name
            0000015: 01           ; string length
            0000016: 67           g  ; import field name
            0000017: 03           ; import kind
            0000018: 7f           ; i32
            0000019: 01           ; global mutability
            000000f: 0a           ; FIXUP section size
            ]]
          else
            error("Unsupported import kind '" .. import.kind .. "'", 0)
          end
        end
  
        imports[i - 1] = import
      end
  
      return imports
    end,
    [3] = function(stream) -- Function Declarations Dection
      local count
      count, stream = parseLEBu(stream, 4)
  
      local typeIndexes = {}
      
      for i = 1, count do
        local type
        type, stream =  parseLEBu(stream, 4)
        typeIndexes[i - 1] = type
      end
  
      return typeIndexes
    end,
    [4] = function(stream) -- Table Section
      local count
      count, stream =  parseLEBu(stream, 4)
  
      local tables = {}
  
      for i = 1, count do
        local type
        type, stream = nibble(stream)
        type = type:byte()
  
        local limits, flag = {}
        flag, stream =  parseLEBu(stream, 1)
        limits.initial =  parseLEBu(stream, 4)
        if flag == 1 then
          limits.maximum =  parseLEBu(stream, 4)
        end
  
        tables[i - 1] = {type = type, limits = limits}
      end
  
      return tables
    end,
    [5] = function(stream) -- Memory Section
      local count
      count, stream =  parseLEBu(stream, 4)
  
      local memories = {}
  
      for i = 1, count do
        local limits, flag = {}
        flag, stream   =  parseLEBu(stream, 1)
        limits.initial =  parseLEBu(stream, 4)
        if flag == 1 then
          limits.maximum =  parseLEBu(stream, 4)
        end
  
        memories[i - 1] = {limits = limits}
      end
  
      return memories
    end,
    [6] = function(stream) -- Global Declarations
      local count
      count, stream =  parseLEBu(stream, 4)
  
      local globals = {}
  
      for i = 1, count do
        local type
        type, stream = nibble(stream)
        type = type:byte()
  
        local mutability
        mutability, stream = parseLEBu(stream, 1)
        
        local initVal
        initVal, stream , brtables= parseInitializerExpr(stream)
        if brtables then
          print("brtable globales .." , table.concat(brtables.brtables,","))
        end
        
        globals[i - 1] = {
          type = type,
          mutability = mutability,
          value = initVal
        }
      end
  
      return globals
    end,
    [7] = function(stream) -- Exports Section
      local count
      count, stream =  parseLEBu(stream, 4)
  
      local exports = {}
      
      for i = 1, count do
        local name
        name, stream =  parseVLString(stream)
  
        local kind
        kind, stream = nibble(stream)
        kind = kind:byte()
        
        local index
        index, stream =  parseLEBu(stream, 4)
  
        exports[name] = {index = index, kind = kind}
      end
  
      return exports
    end,
    [8] = function(stream) -- Start Function
      local index
      index, stream =  parseLEBu(stream, 4)
  
      return index
    end,
    [9] = function(stream) -- Table Elements Section
      local count
      count, stream =  parseLEBu(stream, 4)
  
      local tables = {}
      for i = 1, count do
        local tableIndex
        tableIndex, stream =  parseLEBu(stream, 4)
  
        local offset
        offset, stream = parseInitializerExpr(stream)
  
        local elCount
        elCount, stream =  parseLEBu(stream, 4)
  
        tables[tableIndex] = tables[tableIndex] or {}
        for j = 1, elCount do
          tables[tableIndex][offset + j - 1], stream = parseLEBu(stream, 4)
        end
      end
      return tables
    end,
    [10] = function(stream) -- Function Bodies
      local count
      count, stream = parseLEBu(stream, 4)
  
      local bodies = {}
  
      for i = 1, count do
        local func = {}
  
        local bodySize
        bodySize, stream =  parseLEBu(stream, 4)
  
        local workingStream
        workingStream, stream = stream:sub(1, bodySize), stream:sub(bodySize + 1)
  
        do -- Decode Body
          local localCount
          localCount, workingStream =  parseLEBu(workingStream, 4)
  
          -- Capture locals
          func.locals = {}
          
          for j = 1, localCount do
            local typeCount
            typeCount, workingStream =  parseLEBu(workingStream, 4)
  
            local type
            type, workingStream = nibble(workingStream)
            type = type:byte()
  
            for k = 1, typeCount do
              func.locals[#func.locals + 1] = type
            end
          end
  
          -- Decode instructions
          func.instructions, brtables = decodeFunctionBody(workingStream)
          if brtables then
            func.brtables = brtables;
          end
        end
  
        bodies[i - 1] = func
      end
       
      return bodies
    end,
    [11] = function(stream) -- Data Section
      local count
      count, stream = parseLEBu(stream, 4)
  
      local segments = {}
  
      for i = 1, count do
        local memoryIndex
        memoryIndex, stream =  parseLEBu(stream, 4)
  
        local offsetVal
        offsetVal, stream = parseInitializerExpr(stream)
  
        local data
        data, stream = parseVLString(stream)
  
        segments[i] = {index = memoryIndex, addr = offsetVal, data = data}
      end
  
      return segments
    end
  }


local wasm_loader_decode = function (bytes)
    if bytes:sub(1, WASM_VERSION_MAGIC_LEN) ~= WASM_VERSION_MAGIC then
        print("Not a valid wasm 1.0 binary");
    end
    bytes = bytes:sub(WASM_VERSION_MAGIC_LEN + 1);
    local sectionData = {[0] = {}}
    while #bytes > 0 do
        local sectionID, sectionLength;
        sectionID, bytes = nibble(bytes);
        sectionID        = sectionID:byte();
        sectionLength, bytes = parseLEBu(bytes, 4);
        if sectionID == 0 then
            local sectionName  
            sectionName = parseVLString(bytes)
            local sectionStream, bytes = bytes:sub(1, sectionLength), bytes:sub(sectionLength + 1);
            sectionData[0][#sectionData[0] + 1] = {
              name = sectionName,
              data = sectionStream
            }
        else
            if sections[sectionID] then
                local sectionStream
                sectionStream, bytes = bytes:sub(1, sectionLength), bytes:sub(sectionLength + 1)
                sectionData[sectionID] = sections[sectionID](sectionStream, sectionData)
            else
                print("Invalid section id '" .. sectionID .. "'.. skipping..")
                local sectionStream
                sectionStream, bytes = bytes:sub(1, sectionLength), bytes:sub(sectionLength + 1)
            end
        end
    end
    local instance = compiler.newInstance(sectionData);
    local ccm1_string = require("ccm1_string");
    ccm1_string.bytes = instance.chunk.exports.memory;
    instance:link (
      "ccm1",
      "string_from_cstr_to_value",
      ccm1_string.string_from_cstr
    );

    instance:link (
      "ccm1",
      "string_from_value_to_cstr",
      ccm1_string.string_from_value_to_cstr
    );
    
    return instance.chunk.exports;
end

local wasm_compile = compiler.newInstance;
local wasm_link    = compiler.link;
---------------------------test
local data   = nil;
local handle = io.open("/tmp/bin.wasm", "rb")
---V1.wasm
-- notpass.wasm
-- local handle = io.open("./tests/bin.wasm", "rb")
data   = handle:read("*a");
handle:close();
local exports = wasm_loader_decode(data);


local addr,size  = exports.write_uint8_array({
  string.byte('h'),
  string.byte('e'),
  string.byte('l'),
  string.byte('l'),
  string.byte('o')
});

local addr2,size2  = exports.write_uint8_array({
  string.byte('h'),
  string.byte('e'),
  string.byte('l'),
  string.byte('l'),
  string.byte('o'),
  string.byte('2')
});
--https://blog.csdn.net/yangguanghaozi/article/details/52100501

print(addr, size)
local step = 1;
local size_w = 10000000;

while step <  size_w do
  if step % 2 == 0 then
    exports.murmur_hash2(addr , size);
  else
    exports.djb_hash(addr2 , size2);
  end
  step = step + 1;
end
print('murmur_hash2=>', exports.murmur_hash2(addr , size));
print('murmur_hash2=>', exports.murmur_hash2(addr , size));
print('murmur_hash2=>', exports.murmur_hash2(addr2 , size2));
print('djbhash_=>', exports.djb_hash(addr , size));
print('djbhash_=>', exports.djb_hash(addr , size));
print('djbhash_=>', exports.djb_hash(addr2 , size2));
-- exports.get_module_version2(addr, 5)
-- local t =  exports.read_uint8_array(addr, size)
-- print(table.concat(t, ","))

-- local addr,size  =  exports.write_uint8_array({2,0,0,8,7});

-- exports.get_module_version2(addr, 5)
-- local t =  exports.read_uint8_array(addr, size)
-- print(table.concat(t, ","))



-- local addr1,size1  =  exports.write_uint8_array({1,8,2,1,0,5,1,4,7,0,4,0,0,0,0,0});
-- local addr2,size2  =  exports.write_uint8_array({1,8,2,1,0,5,1,4,7,0,4,0,0,0,0,0});
-- local addr3 = exports.aes_encode(addr1, addr2);


