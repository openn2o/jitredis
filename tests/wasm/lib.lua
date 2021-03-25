local ccm1 = require("ccm1_string");
local imports = {ccm1__warp_from_uint8ptr_to_value = ccm1.ccm1__warp_from_uint8ptr_to_value
,ccm1__string_log = ccm1.ccm1__string_log
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
local A = ffi.new("uint8_t[2097152]")
local ASize = 32
local B = 1048576
local C = {  }
A[1048584] = 65
A[1048585] = 66
A[1048586] = 67
A[1048587] = 68
A[1048588] = 69
A[1048589] = 70
A[1048590] = 71
A[1048591] = 72
A[1048592] = 73
A[1048593] = 74
A[1048594] = 75
A[1048595] = 76
A[1048596] = 77
A[1048597] = 78
A[1048598] = 79
A[1048599] = 80
A[1048600] = 81
A[1048601] = 82
A[1048602] = 83
A[1048603] = 84
A[1048604] = 85
A[1048605] = 86
A[1048606] = 87
A[1048607] = 88
A[1048608] = 89
A[1048609] = 90
A[1048610] = 97
A[1048611] = 98
A[1048612] = 99
A[1048613] = 100
A[1048614] = 101
A[1048615] = 102
A[1048616] = 103
A[1048617] = 104
A[1048618] = 105
A[1048619] = 106
A[1048620] = 107
A[1048621] = 108
A[1048622] = 109
A[1048623] = 110
A[1048624] = 111
A[1048625] = 112
A[1048626] = 113
A[1048627] = 114
A[1048628] = 115
A[1048629] = 116
A[1048630] = 117
A[1048631] = 118
A[1048632] = 119
A[1048633] = 120
A[1048634] = 121
A[1048635] = 122
A[1048636] = 48
A[1048637] = 49
A[1048638] = 50
A[1048639] = 51
A[1048640] = 52
A[1048641] = 53
A[1048642] = 54
A[1048643] = 55
A[1048644] = 56
A[1048645] = 57
A[1048646] = 43
A[1048647] = 47
A[1048648] = 0
local D, E, F, G, H, I
function D()
  error("Unreachable code reached..", 2)
end
function E()
  return 7
end
function F(J, K)
  local L = 0
  local M = 0
 if checkCondition(((J <= 0) and 1 or 0)) then 
	::NStart::
  if true then return -1 end
	::NFinish::
  end
  L = J
 do 
	::OStart::
  M = (L + -1)
 if checkCondition((((readMem(A, ASize, (L + -1)+1048584, 8,3)) == (bit.band(K, 255))) and 1 or 0)) then 
	::PStart::
  if true then return M end
	::PFinish::
  end
 if checkCondition(((L > 1) and 1 or 0)) then 
	::QStart::
  L = M
 goto OStart
	::QFinish::
  end
	::OFinish::
  end
  return -1
end
function G(R, S)
  local T = 0
 if checkCondition(((R <= 0) and 1 or 0)) then 
	::UStart::
  if true then return -1 end
	::UFinish::
  end
  T = 0
 do 
	::VStart::
 if checkCondition((((readMem(A, ASize, T+1048584, 8,3)) == (bit.band(S, 255))) and 1 or 0)) then 
	::WStart::
  if true then return T end
	::WFinish::
  end
  T = (T + 1)
  if checkCondition((((T + 1) < R) and 1 or 0)) then
      goto VStart
  end
	::VFinish::
  end
  return -1
end
function H()
  local X = 0
  local Y = 0
  local Z = 0
  X = B
  Z = (B + -8)
  B = (B + -8)
  Z = (Z + 1)
  Y = (Z + 1)
 storeMem(A, ASize, (Z + 1), 112, 8)
 	Z = Z + 1
 storeMem(A, ASize, Z+1, 104, 8)
  storeMem(A, ASize, Z+2, 101, 8)
  storeMem(A, ASize, Z+3, 101, 8)
  storeMem(A, ASize, Z+4, 114, 8)
  storeMem(A, ASize, Z+5, 112, 8)
  storeMem(A, ASize, Z+6, 0, 8)
   local BA = imports.ccm1__warp_from_uint8ptr_to_value(Y)
  imports.ccm1__string_log(BA)
  local BB = imports.ccm1__warp_from_uint8ptr_to_value(Y)
  B = X
  return BB
end
function I()
  local BC = 0
  local BD = 0
  local BE = 0
  BC = B
  BE = (B + -8)
  B = (B + -8)
  BE = (BE + 1)
  BD = (BE + 1)
 storeMem(A, ASize, (BE + 1), 99, 8)
 	BE = BE + 1
 storeMem(A, ASize, BE+1, 104, 8)
  storeMem(A, ASize, BE+2, 101, 8)
  storeMem(A, ASize, BE+3, 101, 8)
  storeMem(A, ASize, BE+4, 114, 8)
  storeMem(A, ASize, BE+5, 112, 8)
  storeMem(A, ASize, BE+6, 0, 8)
   local BF = imports.ccm1__warp_from_uint8ptr_to_value(BD)
  imports.ccm1__string_log(BF)
  local BG = imports.ccm1__warp_from_uint8ptr_to_value(BD)
  B = BC
  return BG
end
exportTable.main = E
exportTable.t2 = F
exportTable.ccm1_cheerp_version = I
exportTable.ccm1_cheerp_version2 = H
exportTable.memory = A
exportTable.t1 = G
exportTable.memory = A;
exportTable.grow_ip = 0;

---memory init deps
if imports.requires ~= nil then
  for k, v in pairs(imports.requires) do
      v.bytes = A;
  end
end

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
