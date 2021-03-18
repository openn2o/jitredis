local ccm1 = require("ccm1_string");
local imports = {ccm1__warp_from_value_to_uint8ptr = ccm1.ccm1__warp_from_value_to_uint8ptr
,ccm1__warp_from_uint8ptr_to_value = ccm1.ccm1__warp_from_uint8ptr_to_value
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
local D, E, F
function D()
  error("Unreachable code reached..", 2)
end
function E()
  return 0
end
function F(G, H, I)
  local J = 0
  local K = 0
  local L = 0
  local M = 0
  local N = 0
  local O = 0
  local P = 0
  local Q = imports.ccm1__warp_from_value_to_uint8ptr(G)
  J = Q
  local R = imports.ccm1__warp_from_value_to_uint8ptr(H)
  K = R
 if checkCondition(((I == 0) and 1 or 0)) then 
	::SStart::
  storeMem(A, ASize, K, 0, 8)
  local T = imports.ccm1__warp_from_uint8ptr_to_value(K)
  if true then return T end
	::SFinish::
  end
  L = 0
  M = 0
  N = 0
  O = 0
 do 
	::UStart::
  P = (readMem(A, ASize, (N + J), 8))
 do 
	::VStart::
 do 
	::WStart::
 do 
	::XStart::
 do 
	::YStart::
 do 
	::ZStart::
	local eax=O
	local branch_tab = ffi.new('int[3]', {0,1,2})
	if (eax < 3) then
	eax=branch_tab[eax];
	 if eax == 2 then
		 goto VFinish
	 end
	 if eax == 1 then
		 goto WFinish
	 end
	 if eax == 0 then
		 goto XFinish
	 end
	else
		 goto UFinish
	end
	::ZFinish::
  end
  P = P
  local BA = ffi.new("uint8_t[" .. (ASize + 100)*65536 .. "]")
  ffi.copy(BA, A, ASize*65536)
  A, ASize = BA, (ASize + 100)
--debug

  error("Unreachable code reached..", 2)
  error("Unreachable code reached..", 2)
  M = (M + 1)
  O = 1
 goto VFinish
	::YFinish::
  end
  P = P
  local BB = ffi.new("uint8_t[" .. (ASize + 100)*65536 .. "]")
  ffi.copy(BB, A, ASize*65536)
  A, ASize = BB, (ASize + 100)
--debug

  error("Unreachable code reached..", 2)
  error("Unreachable code reached..", 2)
  M = (M + 1)
  O = 2
 goto VFinish
	::XFinish::
  end
  P = P
  local BC = ffi.new("uint8_t[" .. (ASize + 100)*65536 .. "]")
  ffi.copy(BC, A, ASize*65536)
  A, ASize = BC, (ASize + 100)
--debug

  error("Unreachable code reached..", 2)
  error("Unreachable code reached..", 2)
  local BD = ffi.new("uint8_t[" .. (ASize + 100)*65536 .. "]")
  ffi.copy(BD, A, ASize*65536)
  A, ASize = BD, (ASize + 100)
--debug

  error("Unreachable code reached..", 2)
  M = (M + 2)
  O = 0
 goto VFinish
	::WFinish::
  end
  P = P
	::VFinish::
  end
  N = (N + 1)
 if checkCondition((((N + 1) == I) and 1 or 0)) then 
	::BEStart::
  N = (M + K)
 do 
	::BFStart::
 do 
	::BGStart::
 do 
	::BHStart::
	local eax=(O - 1)
	local branch_tab = ffi.new('int[2]', {0,1})
	if (eax < 2) then
	eax=branch_tab[eax];
	 if eax == 1 then
		 goto BGFinish
	 end
	 if eax == 0 then
		 goto BHFinish
	 end
	else
		 goto BFFinish
	end
	::BHFinish::
  end
  local BI = ffi.new("uint8_t[" .. (ASize + 100)*65536 .. "]")
  ffi.copy(BI, A, ASize*65536)
  A, ASize = BI, (ASize + 100)
--debug

  error("Unreachable code reached..", 2)
  error("Unreachable code reached..", 2)
  storeMem(A, ASize, (M + K), 61, 8)
  storeMem(A, ASize, (M + K), 61, 8)
  storeMem(A, ASize, (M + K), 0, 8)
  local BJ = imports.ccm1__warp_from_uint8ptr_to_value(K)
  if true then return BJ end
	::BGFinish::
  end
  local BK = ffi.new("uint8_t[" .. (ASize + 100)*65536 .. "]")
  ffi.copy(BK, A, ASize*65536)
  A, ASize = BK, (ASize + 100)
--debug

  error("Unreachable code reached..", 2)
  error("Unreachable code reached..", 2)
  storeMem(A, ASize, (M + K), 61, 8)
  storeMem(A, ASize, (M + K), 0, 8)
  local BL = imports.ccm1__warp_from_uint8ptr_to_value(K)
  if true then return BL end
	::BFFinish::
  end
  storeMem(A, ASize, 2, 0, 8)
  local BM = imports.ccm1__warp_from_uint8ptr_to_value(K)
  if true then return BM end
	::BEFinish::
  end
  L = P
 goto UStart
	::UFinish::
  end
  return (M + K), 2, (M + K), 2, (M + K), 2, (M + K), 2, (M + K), N, 2, N, 0
end
exportTable.main = E
exportTable.base64_encode = F
exportTable.memory = A
exportTable.memory = A;
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
