local imports = {}
for k, v in pairs(imports) do
  if not imports[k] then
    imports[k] = function(...)
      print("Unlinked Method " .. k);
    end
  end
end
if not imports then imports = {} end 
imports.requires = {}

---link
local bit = require("bit");
local ffi = require("ffi");
local function checkCondition(cond)
  return cond == true or (cond ~= false and cond ~= 0)
end
local function storeMem(mem, memSize, addr, val, bytes, type)
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to store outside bounds", 2)
  end
  if bytes == 8 then
    ffi.cast("uint" .. bytes .. "_t*", mem + addr)[0] = val
  else
    if type == 1 then
      ffi.cast("int" .. bytes .. "_t*", mem + addr)[0] = val
    end
    
  end
end
local function storeFloat(mem, memSize, addr, val, bytes)
  val = val or 0
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to store outside bounds", 2)
  end
  if bytes == 8 then
    ffi.cast("double*", mem + addr)[0] = val
  else
    ffi.cast("float*", mem + addr)[0] = val
  end
end
---debug10081
local function readMem(mem, memSize, addr, bytes, type)
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to read outside bounds " .. addr, 2)
  end
  if bytes == 8 then
    return ffi.cast("uint" .. bytes .. "_t*", mem + addr)[0]
  else
    print("1111")
    local m = ffi.cast("int" .. bytes .. "_t*", mem + addr)[0];
    if type == 1 then
      -- i32 unsigned
      -- 4294967295 
      if m < 0 then
        return (4294967295 + m ) + 1;
      end
    end
    return  m;
  end
end
local exportTable = {}
local A = ffi.new("uint8_t[65536]")
local ASize = 1
local B, C, D, E, F, G, H, I, J
function B()
 storeMem(A, ASize, 0, 251, 8)
  storeMem(A, ASize, 1, 252, 8)
  storeMem(A, ASize, 2, 253, 8)
  storeMem(A, ASize, 3, 254, 8)
   return (readMem(A, ASize, 0, 32, 1))
end
function C()
  storeMem(A, ASize, 0, 51913, 16)
  storeMem(A, ASize, 2, 52427, 16)
  return (readMem(A, ASize, 0, 32, 1))
end
function D()
  storeMem(A, ASize, 0, -123456, 32)
  return (readMem(A, ASize, 0, 32, 1))
end
function E()
  storeMem(A, ASize, 0, -286331141, 8)
  storeMem(A, ASize, 1, -286331140, 8)
  storeMem(A, ASize, 2, -286331139, 8)
  storeMem(A, ASize, 3, -286331138, 8)
  return (readMem(A, ASize, 0, 32, 1))
end
function F()
  storeMem(A, ASize, 0, -286331159, 16)
  storeMem(A, ASize, 2, -286331157, 16)
  return (readMem(A, ASize, 0, 32, 1))
end
function G()
  storeMem(A, ASize, 0, -123456, 32)
  return (readMem(A, ASize, 0, 32, 1))
end
function H()
  storeMem(A, ASize, nil, (math.floor(0 / 2061357277)), 64)
  return (ffi.cast("uint64_t*", A + 0)[0])
end
function I()
  storeFloat(A, ASize, 0, 1.5, 32)
  return (readMem(A, ASize, 0, 32, 1))
end
function J()
  storeFloat(A, ASize, 0, -1000.75, 8)  return (readMem(A, ASize, 4, 32, 1))
end
exportTable.i64_store8 = E
exportTable.f32_store = I
exportTable.i32_store = D
exportTable.i32_store8 = B
exportTable.i64_store16 = F
exportTable.i32_store16 = C
exportTable.i64_store32 = G
exportTable.f64_store = J
exportTable.i64_store = H
exportTable.memory = A;
exportTable.grow_ip = 0;
print(exportTable.f32_store() ,'=> i32:1069547520')
exportTable.write_uint8_array = function (buff) 
  local len = table.getn(buff);
  if len < 1 then
    return -1;
  end 
  local i    = exportTable.grow_ip;
  local dist = exportTable.grow_ip + len;
  local d    = 1;
  while i < dist do
    exportTable.memory[i] = buff[ d ];
    i = i + 1;
    d = d + 1;
  end
  exportTable.grow_ip = exportTable.grow_ip + len;
  return exportTable.grow_ip - len, len;
end

exportTable.read_uint8_array = function (i, len) 
  local dist = i + len;
  local tmp  = {}
  while dist > i do
    tmp [#tmp + 1] = exportTable.memory[i];
    i = i+1;
  end
  return tmp;
end

return { exports = exportTable, importTable = imports, }
