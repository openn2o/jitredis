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
local brtable_mems_002 = {
  4294967295, 
  0,
  0,
  4294967295,
  65535,
  0,
  0,
  65535,
  4294967295
}
local function readMem(mem, memSize, addr, bytes, type)
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to read outside bounds " .. addr, 2)
  end
  if bytes == 8 then
    local m =  ffi.cast("uint" .. bytes .. "_t*", mem + addr)[0];
    if type == 2 then
      --i32.load8s
      if 127 < m then
         return  4294967295;
      end
    end
    if type == 6 then
      --i64.load8s
      if m > 127 then
        return 18446744073709551615;
      end
    end

    if type == 7 then
      if m > 255 then
        return 255;
      end
    end
    return m;
  else
    local m = ffi.cast("int" .. bytes .. "_t*", mem + addr)[0];
    if m < 0 then
      return brtable_mems_002[type];
    end
    return  m;
  end
end
local exportTable = {}
local A = ffi.new("uint8_t[65536]")
local ASize = 1
A[0] = 255
A[1] = 255
A[2] = 255
A[3] = 255
A[4] = 0
A[4] = 0
A[5] = 0
A[6] = 206
A[7] = 65
A[8] = 0
A[8] = 0
A[9] = 0
A[10] = 0
A[11] = 0
A[12] = 0
A[13] = 255
A[14] = 143
A[15] = 64
A[16] = 0
A[16] = 255
A[17] = 255
A[18] = 255
A[19] = 255
A[20] = 255
A[21] = 255
A[22] = 255
A[23] = 255
A[24] = 0
local B, C, D, E, F, G, H, I, J, K, L, M, N, O
function B()
  return (readMem(A, ASize, 0, 8,2))
end
function C()
  return (readMem(A, ASize, 0, 16,4))
end
function D()
  return (readMem(A, ASize, 0, 32, 1))
end
function E()
  return (readMem(A, ASize, 0, 8,3))
end
function F()
  return (readMem(A, ASize, 0, 16,5))
end
function G()
  return (readMem(A, ASize, 0, 8,6))
end
function H()
  return (ffi.cast("uint64_t*", A + 0)[0])
end
function I()
  return (ffi.cast("uint64_t*", A + 0)[0])
end
function J()
  return (ffi.cast("uint64_t*", A + 16)[0])
end
function K()
  return (readMem(A, ASize, 0, 8,7))
end
function L()
  return (readMem(A, ASize, 0, 16,8))
end
function M()
  return (readMem(A, ASize, 0, 16,9))
end
function N()
  return (ffi.cast("float*", A + 4)[0])
end
function O()
  return (ffi.cast("double*", A + 8)[0])
end
exportTable.i32_load8_s = B
exportTable.i64_load8_s = G
exportTable.f64_load = O
exportTable.i64_load32_s = I
exportTable.i64_load16_u = L
exportTable.f32_load = N
exportTable.i32_load16_u = F
exportTable.i64_load16_s = H
exportTable.i64_load8_u = K
exportTable.i32_load16_s = C
exportTable.i32_load8_u = E
exportTable.i64_load = J
exportTable.i64_load32_u = M
exportTable.i32_load = D
exportTable.memory = A;
exportTable.grow_ip = 0;
print(exportTable.i32_load8_s(), " => i32:4294967295 ");
print(exportTable.i32_load16_s() ,"=> i32:4294967295");
print(exportTable.i32_load(), "=> i32:4294967295" ); 
print(exportTable.i32_load8_u() ,"=> i32:255");
print(exportTable.i32_load16_u() ,"=> i32:65535");
print(exportTable.i64_load8_s(), "=> i64:18446744073709551615" );
print(exportTable.i64_load16_s() ,"=> i64:18446744073709551615");
print(exportTable.i64_load32_s() ,"=> i64:18446744073709551615");
print(exportTable.i64_load() ," => i64:18446744073709551615" );
print(exportTable.i64_load8_u()," => i64:255" );
print(exportTable.i64_load16_u() ,"=> i64:65535");
print(exportTable.i64_load32_u() ,"=> i64:4294967295" );
print(exportTable.f32_load() ,"=> f32:25.750000");
print(exportTable.f64_load() , "=> f64:1023.875000" ); 
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
