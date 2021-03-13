local ccm1 = require("ccm1_string");
local imports = {ccm1__string_new = ccm1.ccm1__string_new
,ccm1__string_log = ccm1.ccm1__string_log
,ccm1__dynamic_string_new = ccm1.ccm1__dynamic_string_new
,ccm1__string_from_cstr_to_value = ccm1.ccm1__string_from_cstr_to_value
,ccm1__dynamic_string_append = ccm1.ccm1__dynamic_string_append
,ccm1__dynamic_string_log = ccm1.ccm1__dynamic_string_log
,ccm1__dynamic_string_join = ccm1.ccm1__dynamic_string_join
,ccm1__warp_from_uint8ptr_to_value = ccm1.ccm1__warp_from_uint8ptr_to_value
,ccm1__warp_from_value_to_uint8ptr = ccm1.ccm1__warp_from_value_to_uint8ptr
,}
for k, v in pairs(imports) do
  if not imports[k] then
    imports[k] = function(...)
      print("Unlinked Method " .. k);
    end
  end
end
imports.requires = {}
imports.requires['ccm1']=ccm1;
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
A[1048584] = 105
A[1048585] = 32
A[1048586] = 97
A[1048587] = 109
A[1048588] = 32
A[1048589] = 99
A[1048590] = 111
A[1048591] = 110
A[1048592] = 115
A[1048593] = 116
A[1048594] = 49
A[1048595] = 0
A[1048596] = 105
A[1048597] = 32
A[1048598] = 97
A[1048599] = 109
A[1048600] = 32
A[1048601] = 99
A[1048602] = 111
A[1048603] = 110
A[1048604] = 115
A[1048605] = 116
A[1048606] = 50
A[1048607] = 44
A[1048608] = 0
A[1048609] = 7
A[1048610] = 8
A[1048611] = 9
A[1048612] = 10
A[1048613] = 11
A[1048614] = 12
A[1048615] = 13
A[1048865] = 104
A[1048866] = 101
A[1048867] = 108
A[1048868] = 108
A[1048869] = 111
local D, E, F, G
function D()
  error("Unreachable code reached..", 2)
end
function E()
  local H = 0
  local I = 0
  local J = 0
  local K = 0
  H = B
  J = (-256 + H)
  B = (-256 + H)
  local L = imports.ccm1__string_new(1048584)
  I = L
  J = J
  K = 0
 do 
	::MStart::
  local N = imports.ccm1__string_from_cstr_to_value(1048865)
  imports.ccm1__string_log(N)
  K = (K + 1)
  if checkCondition((((K + 1) ~= 1000) and 1 or 0)) then
      goto MStart
  end
	::MFinish::
  end
  imports.ccm1__string_log(L)
  local O = imports.ccm1__dynamic_string_new()
  K = O
  local P = imports.ccm1__string_from_cstr_to_value(1048596)
  local Q = imports.ccm1__dynamic_string_append(O, P)
  local R = imports.ccm1__dynamic_string_append(K, I)
  imports.ccm1__dynamic_string_log(K)
  local S = imports.ccm1__dynamic_string_join(K)
  imports.ccm1__dynamic_string_log(S)
  K = J
  local T = F(J, 1048609, 256)
  storeMem(A, ASize, J, 32, 16)
  storeMem(A, ASize, J, 808460336, 32)
  storeMem(A, ASize, K, 808464432, 64)
  storeMem(A, ASize, J, 808464432, 64)
  local U = imports.ccm1__warp_from_uint8ptr_to_value(K)
  imports.ccm1__dynamic_string_log(U)
  B = B
  return 0
end
function F(V, W, X)
  local Y = 0
  local Z = 0
  local BA = 0
  local BB = 0
  local BC = 0
  Y = (X + W)
 do 
	::BDStart::
 if checkCondition((bit.band(V, 3))) then 
	::BEStart::
  BA = W
  Z = V
 do 
	::BFStart::
  if checkCondition(((BA == Y) and 1 or 0)) then
      goto BDFinish
  end
  storeMem(A, ASize, Z, (readMem(A, ASize, BA, 8)), 8)
  BA = (1 + BA)
  Z = (1 + Z)
  if checkCondition((bit.band((1 + Z), 3))) then
      goto BFStart
  end
	::BFFinish::
  end
  else
  Z = V
  BA = W
	::BEFinish::
  end
  BB = BA
  BC = (-64 + Y)
 if checkCondition(((BA <= (-64 + Y)) and 1 or 0)) then 
	::BGStart::
 do 
	::BHStart::
  storeMem(A, ASize, Z, (ffi.cast("uint64_t*", A + BA)[0]), 64)
  storeMem(A, ASize, Z, (ffi.cast("uint64_t*", A + BA)[0]), 64)
  storeMem(A, ASize, Z, (ffi.cast("uint64_t*", A + BA)[0]), 64)
  storeMem(A, ASize, Z, (ffi.cast("uint64_t*", A + BA)[0]), 64)
  storeMem(A, ASize, Z, (ffi.cast("uint64_t*", A + BA)[0]), 64)
  storeMem(A, ASize, Z, (ffi.cast("uint64_t*", A + BA)[0]), 64)
  storeMem(A, ASize, Z, (ffi.cast("uint64_t*", A + BA)[0]), 64)
  storeMem(A, ASize, Z, (ffi.cast("uint64_t*", A + BA)[0]), 64)
  BA = (64 + BA)
  Z = (64 + Z)
  if checkCondition((((64 + BA) <= BC) and 1 or 0)) then
      goto BHStart
  end
	::BHFinish::
  end
  BB = BA
	::BGFinish::
  end
  BC = (-8 + Y)
 if checkCondition(((BB <= BC) and 1 or 0)) then 
	::BIStart::
 do 
	::BJStart::
  storeMem(A, ASize, Z, (ffi.cast("uint64_t*", A + BA)[0]), 64)
  BA = (8 + BA)
  Z = (8 + Z)
  if checkCondition((((8 + BA) <= BC) and 1 or 0)) then
      goto BJStart
  end
	::BJFinish::
  end
	::BIFinish::
  end
  if checkCondition(((BA == Y) and 1 or 0)) then
      goto BDFinish
  end
 do 
	::BKStart::
  storeMem(A, ASize, Z, (readMem(A, ASize, BA, 8)), 8)
  BA = (1 + BA)
  if checkCondition((((1 + BA) == Y) and 1 or 0)) then
      goto BDFinish
  end
  Z = (1 + Z)
 goto BKStart
	::BKFinish::
  end
	::BDFinish::
  end
  return V
end
function G(BL, BM, BN)
  local BO = 0
  local BP = 0
  local BQ = 0
  local BR = 0
  local BS = 0
  local BT = 0
  local BU = 0
  local BV = 0
  local BW = imports.ccm1__warp_from_value_to_uint8ptr(BL)
  BO = BW
  local BX = imports.ccm1__warp_from_value_to_uint8ptr(BM)
  BP = BX
 if checkCondition(((BN > 0) and 1 or 0)) then 
	::BYStart::
  BU = 0
 do 
	::BZStart::
  BV = (readMem(A, ASize, (BU + BP), 8))
  BT = (BU * 3)
  BQ = (bit.rshift(BV, 4))
  BR = (BQ + 48)
  storeMem(A, ASize, ((BU * 3) + BO), (checkCondition((((bit.band(BR, 255)) > 57) and 1 or 0)) and ((bit.rshift(BV, 4)) + 55)) or ((BQ + 48)), 8)
  BV = (bit.band(BV, 15))
  BS = (BV + 48)
  storeMem(A, ASize, (BT + BO), (checkCondition((((bit.band(BS, 255)) > 57) and 1 or 0)) and ((bit.band(BV, 15)) + 55)) or ((BV + 48)), 8)
  storeMem(A, ASize, (BT + BO), 32, 8)
  BU = (BU + 1)
  if checkCondition((((BU + 1) ~= BN) and 1 or 0)) then
      goto BZStart
  end
	::BZFinish::
  end
	::BYFinish::
  end
  storeMem(A, ASize, ((BN * 3) + BO), 0, 8)
end
exportTable.main = E
exportTable.TA_HexToStr = G
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
