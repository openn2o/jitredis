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
local function storeMem(mem, memSize, addr, val, bytes)
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to store outside bounds", 2)
  end
  if bytes == 8 then
    ffi.cast("uint" .. bytes .. "_t*", mem + addr)[0] = val
  else
    ffi.cast("int" .. bytes .. "_t*", mem + addr)[0] = val
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
local function readMem(mem, memSize, addr, bytes)
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to read outside bounds " .. addr, 2)
  end
  if bytes == 8 then
    return ffi.cast("uint" .. bytes .. "_t*", mem + addr)[0]
  else
    return ffi.cast("int" .. bytes .. "_t*", mem + addr)[0]
  end
end
local exportTable = {}
local A = ffi.new("uint8_t[65536]")
local ASize = 1
A[0] = 49
A[1] = 54
A[2] = 51
A[3] = 56
A[4] = 51
A[5] = 49
A[6] = 54
A[7] = 51
A[8] = 56
A[9] = 51
A[10] = 48
A[11] = 54
A[12] = 53
A[13] = 0
local B, C, D, E, F, G, H, I, J, K, L, M, N, O
function B()
  return (readMem(A, ASize, 0, 8))
end
function C()
  return (readMem(A, ASize, 0, 16))
end
function D()
  return (readMem(A, ASize, 0, 32))
end
function E()
  return (readMem(A, ASize, 0, 8))
end
function F()
  return (readMem(A, ASize, 0, 16))
end
function G()
  return (ffi.cast("uint64_t*", A + 0)[0])
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
  return (ffi.cast("uint64_t*", A + 0)[0])
end
function L()
  return (ffi.cast("uint64_t*", A + 0)[0])
end
function M()
  return (ffi.cast("uint64_t*", A + 0)[0])
end
function N()
  return (ffi.cast("float*", A + 4)[0])
end
function O()
  return (ffi.cast("double*", A + 8)[0])
end
exportTable.i64_load8_s = G
exportTable.i32_load8_s = B
exportTable.i32_load16_u = F
exportTable.i64_load16_u = L
exportTable.i32_load = D
exportTable.f32_load = N
exportTable.i64_load8_u = K
exportTable.i32_load8_u = E
exportTable.i32_load16_s = C
exportTable.i64_load16_s = H
exportTable.f64_load = O
exportTable.i64_load32_u = M
exportTable.i64_load = J
exportTable.i64_load32_s = I
exportTable.memory = A;
exportTable.grow_ip = 0;


print(".........")
print(exportTable.i32_load8_s());-- => i32:4294967295
print(exportTable.i32_load16_s() );-- => i32:4294967295
print(exportTable.i32_load() );-- => i32:4294967295
print(exportTable.i32_load8_u() );-- => i32:255
print(exportTable.i32_load16_u() );-- => i32:65535
print(exportTable.i64_load8_s() );-- => i64:18446744073709551615
print(exportTable.i64_load16_s() );-- => i64:18446744073709551615
print(exportTable.i64_load32_s() );-- => i64:18446744073709551615
print(exportTable.i64_load() );-- => i64:18446744073709551615
print(exportTable.i64_load8_u() );-- => i64:255
print(exportTable.i64_load16_u() );-- => i64:65535
print(exportTable.i64_load32_u() );-- => i64:4294967295
print(exportTable.f32_load() );-- => f32:25.750000
print(exportTable.f64_load() );-- => f64:1023.875000


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
