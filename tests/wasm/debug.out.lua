local ccm1 = require("ccm1_string");
local imports = {ccm1__log = ccm1.ccm1__log
,ccm1__warp_from_value_to_uint8ptr = ccm1.ccm1__warp_from_value_to_uint8ptr
,}
for k, v in pairs(imports) do
  if not imports[k] then
    imports[k] = function(...)
      print("Unlinked Method " .. k);
    end
  end
end
if not imports then imports = {} end 
imports.requires = {}
imports.requires['ccm1']=ccm1;

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
local A = ffi.new("uint8_t[1114112]")
local ASize = 17
exportTable.memory = A
local B = 1048576
local C = {  }
local D, E, F, G, H, I, J, K
function D()
  error("Unreachable code reached..", 2)
end
function E(L)
  local M = 0
  local N = 0
  local O = 0
  N = (L + -1)
 if checkCondition((((L + -1) < 2) and 1 or 0)) then 
	::PStart::
  if true then return 1 end
	::PFinish::
  end
  O = 1
  M = L
 do 
	::QStart::
  local R = E(N)
  O = (R + O)
  N = (M + -3)
 if checkCondition((((M + -3) < 2) and 1 or 0)) then 
	::SStart::
  if true then return O end
	::SFinish::
  end
  M = (M + -2)
 goto QStart
	::QFinish::
  end
  return 0
end
function F()
  local T = E(40)
  imports.ccm1__log(T)
  return 0
end
function G(U, V)
  local W = imports.ccm1__warp_from_value_to_uint8ptr(U)
  error("Unreachable code reached..", 2)
  error("Unreachable code reached..", 2)
end
function H(X, Y)
  return ((checkCondition(((X > Y) and 1 or 0)) and X) or (Y) * 100)
end
function I(Z, BA)
  return (checkCondition(((Z > BA) and 1 or 0)) and Z) or (BA)
end
function J(BB, BC)
  return (checkCondition(((BB > BC) and 1 or 0)) and BB) or (BC)
end
function K(BD, BE)
  return (checkCondition(((BD > BE) and 1 or 0)) and BD) or (BE)
end
exportTable.base64_encode = G
exportTable.test_max2 = J
exportTable.test_max1 = K
exportTable.fab = E
exportTable.main = F
exportTable.test_max3 = I
exportTable.test_max4 = H
exportTable.memory = A
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

return { exports = exportTable, importTable = imports, }
