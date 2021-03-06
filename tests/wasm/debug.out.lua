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
local A, B, C, D, E, F, G, H, I, J, K, L
function A(M)
  return (checkCondition(M == 0) and 2) or (1)
end
function B(N)
  return (checkCondition(N == 0) and 2) or (1)
end
function C(O)
  return (checkCondition(O == 0) and 2) or (1)
end
function D(P)
  return (checkCondition(P == 0) and 2) or (1)
end
function E()
  local Q = A(0)
  return Q
end
function F()
  local R = A(1)
  return R
end
function G()
  local S = B(0)
  return S
end
function H()
  local T = B(1)
  return T
end
function I()
  local U = C(0)
  return U
end
function J()
  local V = C(1)
  return V
end
function K()
  local W = D(0)
  return W
end
function L()
  local X = D(1)
  return X
end
exportTable.test_f32_l = I
exportTable.test_i64_r = H
exportTable.test_f64_r = L
exportTable.test_f32_r = J
exportTable.test_f64_l = K
exportTable.test_i32_r = F
exportTable.test_i32_l = E
exportTable.test_i64_l = G
if exportTable.main ~= nil then
  print(exportTable.main());
end
exportTable.grow_ip = 0;

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

return { exports = exportTable, }
