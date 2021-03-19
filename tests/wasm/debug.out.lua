local ccm1 = require("ccm1_string");
local imports = {ccm1__string_from_cstr_to_value = ccm1.ccm1__string_from_cstr_to_value
,ccm1__warp_from_uint8ptr_to_value = ccm1.ccm1__warp_from_uint8ptr_to_value
,ccm1__string_log = ccm1.ccm1__string_log
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
local A = ffi.new("uint8_t[2097152]")
local ASize = 32
local B = 1048576
local C = {  }
A[1048584] = 49
A[1048585] = 48
A[1048586] = 52
A[1048587] = 49
A[1048588] = 48
A[1048589] = 49
A[1048590] = 49
A[1048591] = 48
A[1048592] = 56
A[1048593] = 49
A[1048594] = 48
A[1048595] = 56
A[1048596] = 49
A[1048597] = 49
A[1048598] = 49
A[1048599] = 48
A[1048600] = 54
A[1048601] = 53
A[1048602] = 54
A[1048603] = 54
A[1048604] = 54
A[1048605] = 55
A[1048606] = 54
A[1048607] = 56
A[1048608] = 54
A[1048609] = 57
A[1048610] = 55
A[1048611] = 48
A[1048612] = 55
A[1048613] = 49
A[1048614] = 55
A[1048615] = 50
A[1048616] = 55
A[1048617] = 51
A[1048618] = 55
A[1048619] = 52
A[1048620] = 55
A[1048621] = 53
A[1048622] = 55
A[1048623] = 54
A[1048624] = 55
A[1048625] = 55
A[1048626] = 55
A[1048627] = 56
A[1048628] = 55
A[1048629] = 57
A[1048630] = 56
A[1048631] = 48
A[1048632] = 56
A[1048633] = 49
A[1048634] = 56
A[1048635] = 50
A[1048636] = 56
A[1048637] = 51
A[1048638] = 56
A[1048639] = 52
A[1048640] = 56
A[1048641] = 53
A[1048642] = 56
A[1048643] = 54
A[1048644] = 56
A[1048645] = 55
A[1048646] = 56
A[1048647] = 56
A[1048648] = 56
A[1048649] = 57
A[1048650] = 57
A[1048651] = 48
A[1048652] = 57
A[1048653] = 55
A[1048654] = 57
A[1048655] = 56
A[1048656] = 57
A[1048657] = 57
A[1048658] = 49
A[1048659] = 48
A[1048660] = 48
A[1048661] = 49
A[1048662] = 48
A[1048663] = 49
A[1048664] = 49
A[1048665] = 48
A[1048666] = 50
A[1048667] = 49
A[1048668] = 48
A[1048669] = 51
A[1048670] = 49
A[1048671] = 48
A[1048672] = 52
A[1048673] = 49
A[1048674] = 48
A[1048675] = 53
A[1048676] = 49
A[1048677] = 48
A[1048678] = 54
A[1048679] = 49
A[1048680] = 48
A[1048681] = 55
A[1048682] = 49
A[1048683] = 48
A[1048684] = 56
A[1048685] = 49
A[1048686] = 48
A[1048687] = 57
A[1048688] = 49
A[1048689] = 49
A[1048690] = 48
A[1048691] = 49
A[1048692] = 49
A[1048693] = 49
A[1048694] = 49
A[1048695] = 49
A[1048696] = 50
A[1048697] = 49
A[1048698] = 49
A[1048699] = 51
A[1048700] = 49
A[1048701] = 49
A[1048702] = 52
A[1048703] = 49
A[1048704] = 49
A[1048705] = 53
A[1048706] = 49
A[1048707] = 49
A[1048708] = 54
A[1048709] = 49
A[1048710] = 49
A[1048711] = 55
A[1048712] = 49
A[1048713] = 49
A[1048714] = 56
A[1048715] = 49
A[1048716] = 49
A[1048717] = 57
A[1048718] = 49
A[1048719] = 50
A[1048720] = 48
A[1048721] = 49
A[1048722] = 50
A[1048723] = 49
A[1048724] = 49
A[1048725] = 50
A[1048726] = 50
A[1048727] = 52
A[1048728] = 56
A[1048729] = 52
A[1048730] = 57
A[1048731] = 53
A[1048732] = 48
A[1048733] = 53
A[1048734] = 49
A[1048735] = 53
A[1048736] = 50
A[1048737] = 53
A[1048738] = 51
A[1048739] = 53
A[1048740] = 52
A[1048741] = 53
A[1048742] = 53
A[1048743] = 53
A[1048744] = 54
A[1048745] = 53
A[1048746] = 55
A[1048747] = 52
A[1048748] = 51
A[1048749] = 52
A[1048750] = 55
A[1048751] = 0
local D, E, F
function D()
  error("Unreachable code reached..", 2)
end
function E(G, H, I)
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
 storeMem(A, ASize, (M + K), (readMem(A, ASize, (bit.rshift(P, 2))+1048590, 8)), 8)
   M = (M + 1)
  O = 1
 goto VFinish
	::YFinish::
  end
  P = P
 storeMem(A, ASize, (M + K), (readMem(A, ASize, (bit.bor((bit.rshift(P, 4)), (bit.band((bit.lshift(L, 4)), 48))))+1048590, 8)), 8)
   M = (M + 1)
  O = 2
 goto VFinish
	::XFinish::
  end
  P = P
 storeMem(A, ASize, (M + K), (readMem(A, ASize, (bit.bor((bit.rshift(P, 6)), (bit.band((bit.lshift(L, 2)), 60))))+1048590, 8)), 8)
  storeMem(A, ASize, (M + K)+1, (readMem(A, ASize, (bit.band(P, 63))+1048590, 8)), 8)
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
	::BAStart::
  N = (M + K)
 do 
	::BBStart::
 do 
	::BCStart::
 do 
	::BDStart::
	local eax=(O - 1)
	local branch_tab = ffi.new('int[2]', {0,1})
	if (eax < 2) then
	eax=branch_tab[eax];
	 if eax == 1 then
		 goto BCFinish
	 end
	 if eax == 0 then
		 goto BDFinish
	 end
	else
		 goto BBFinish
	end
	::BDFinish::
  end
 storeMem(A, ASize, N, (readMem(A, ASize, (bit.band((bit.lshift(P, 4)), 48))+1048590, 8)), 8)
  storeMem(A, ASize, (M + K)+1, 61, 8)
  storeMem(A, ASize, (M + K)+2, 61, 8)
  storeMem(A, ASize, (M + K)+3, 0, 8)
   local BE = imports.ccm1__warp_from_uint8ptr_to_value(K)
  if true then return BE end
	::BCFinish::
  end
 storeMem(A, ASize, N, (readMem(A, ASize, (bit.band((bit.lshift(P, 2)), 60))+1048590, 8)), 8)
  storeMem(A, ASize, (M + K)+1, 61, 8)
  storeMem(A, ASize, (M + K)+2, 0, 8)
   local BF = imports.ccm1__warp_from_uint8ptr_to_value(K)
  if true then return BF end
	::BBFinish::
  end
 storeMem(A, ASize, (M + K), 0, 8)
   local BG = imports.ccm1__warp_from_uint8ptr_to_value(K)
  if true then return BG end
	::BAFinish::
  end
  L = P
 goto UStart
	::UFinish::
  end
  return 0
end
function F()
  local BH = 0
  local BI = 0
  local BJ = 0
  local BK = 0
  BH = B
  BK = (B + -16)
  B = (B + -16)
  BK = (BK + 6)
  BI = (BK + 6)
 storeMem(A, ASize, (BK + 6), 1, 8)
 	BK = ( 6+BK )
 storeMem(A, ASize, BK+1, 2, 8)
  storeMem(A, ASize, BK+2, 3, 8)
  storeMem(A, ASize, BK+3, 4, 8)
  storeMem(A, ASize, BK+4, 5, 8)
  storeMem(A, ASize, BK+5, 6, 8)
  storeMem(A, ASize, BK+6, 7, 8)
  storeMem(A, ASize, BK+7, 8, 8)
  storeMem(A, ASize, BK+8, 9, 8)
  storeMem(A, ASize, BK+9, 10, 8)
   local BL = imports.ccm1__string_from_cstr_to_value(1048584)
  local BM = imports.ccm1__warp_from_uint8ptr_to_value(BI)
  BJ = BM
  local BN = E(BL, BM, 4)
  imports.ccm1__string_log(BJ)
  B = BH
  return 0
end
exportTable.base64_encode = E
exportTable.memory = A
exportTable.main = F
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
