
(client = (require("redis")).createClient(require("./config.js"))) ["sumavlib.biz_script_register"]([
	/* 实时计算函数的名称 */ "Calc", 
	/* 实时计算函数 */
	`
	 local _M = {}
	 _M.process = function ()
		redis.log(redis.LOG_WARNING, 'Calc3')
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


	 end
	 return _M;
	`
	],function(e) {
	 console.log("sumavlib function install");
	 client.end(true);
});
