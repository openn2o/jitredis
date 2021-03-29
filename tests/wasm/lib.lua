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
A[1048584] = 104
A[1048585] = 101
A[1048586] = 108
A[1048587] = 108
A[1048588] = 111
A[1048589] = 0
A[1048590] = 255
A[1048591] = 255
A[1048592] = 255
A[1048593] = 255
A[1048594] = 255
A[1048595] = 255
A[1048596] = 255
A[1048597] = 255
A[1048598] = 255
A[1048599] = 255
A[1048600] = 255
A[1048601] = 255
A[1048602] = 255
A[1048603] = 255
A[1048604] = 255
A[1048605] = 255
A[1048606] = 255
A[1048607] = 255
A[1048608] = 255
A[1048609] = 255
A[1048610] = 255
A[1048611] = 255
A[1048612] = 255
A[1048613] = 255
A[1048614] = 255
A[1048615] = 255
A[1048616] = 255
A[1048617] = 255
A[1048618] = 255
A[1048619] = 255
A[1048620] = 255
A[1048621] = 255
A[1048622] = 255
A[1048623] = 255
A[1048624] = 255
A[1048625] = 255
A[1048626] = 255
A[1048627] = 255
A[1048628] = 255
A[1048629] = 255
A[1048630] = 255
A[1048631] = 255
A[1048632] = 255
A[1048633] = 62
A[1048634] = 255
A[1048635] = 255
A[1048636] = 255
A[1048637] = 63
A[1048638] = 52
A[1048639] = 53
A[1048640] = 54
A[1048641] = 55
A[1048642] = 56
A[1048643] = 57
A[1048644] = 58
A[1048645] = 59
A[1048646] = 60
A[1048647] = 61
A[1048648] = 255
A[1048649] = 255
A[1048650] = 255
A[1048651] = 255
A[1048652] = 255
A[1048653] = 255
A[1048654] = 255
A[1048655] = 0
A[1048656] = 1
A[1048657] = 2
A[1048658] = 3
A[1048659] = 4
A[1048660] = 5
A[1048661] = 6
A[1048662] = 7
A[1048663] = 8
A[1048664] = 9
A[1048665] = 10
A[1048666] = 11
A[1048667] = 12
A[1048668] = 13
A[1048669] = 14
A[1048670] = 15
A[1048671] = 16
A[1048672] = 17
A[1048673] = 18
A[1048674] = 19
A[1048675] = 20
A[1048676] = 21
A[1048677] = 22
A[1048678] = 23
A[1048679] = 24
A[1048680] = 25
A[1048681] = 255
A[1048682] = 255
A[1048683] = 255
A[1048684] = 255
A[1048685] = 255
A[1048686] = 255
A[1048687] = 26
A[1048688] = 27
A[1048689] = 28
A[1048690] = 29
A[1048691] = 30
A[1048692] = 31
A[1048693] = 32
A[1048694] = 33
A[1048695] = 34
A[1048696] = 35
A[1048697] = 36
A[1048698] = 37
A[1048699] = 38
A[1048700] = 39
A[1048701] = 40
A[1048702] = 41
A[1048703] = 42
A[1048704] = 43
A[1048705] = 44
A[1048706] = 45
A[1048707] = 46
A[1048708] = 47
A[1048709] = 48
A[1048710] = 49
A[1048711] = 50
A[1048712] = 51
A[1048713] = 255
A[1048714] = 255
A[1048715] = 255
A[1048716] = 255
A[1048717] = 255
A[1048718] = 65
A[1048719] = 66
A[1048720] = 67
A[1048721] = 68
A[1048722] = 69
A[1048723] = 70
A[1048724] = 71
A[1048725] = 72
A[1048726] = 73
A[1048727] = 74
A[1048728] = 75
A[1048729] = 76
A[1048730] = 77
A[1048731] = 78
A[1048732] = 79
A[1048733] = 80
A[1048734] = 81
A[1048735] = 82
A[1048736] = 83
A[1048737] = 84
A[1048738] = 85
A[1048739] = 86
A[1048740] = 87
A[1048741] = 88
A[1048742] = 89
A[1048743] = 90
A[1048744] = 97
A[1048745] = 98
A[1048746] = 99
A[1048747] = 100
A[1048748] = 101
A[1048749] = 102
A[1048750] = 103
A[1048751] = 104
A[1048752] = 105
A[1048753] = 106
A[1048754] = 107
A[1048755] = 108
A[1048756] = 109
A[1048757] = 110
A[1048758] = 111
A[1048759] = 112
A[1048760] = 113
A[1048761] = 114
A[1048762] = 115
A[1048763] = 116
A[1048764] = 117
A[1048765] = 118
A[1048766] = 119
A[1048767] = 120
A[1048768] = 121
A[1048769] = 122
A[1048770] = 48
A[1048771] = 49
A[1048772] = 50
A[1048773] = 51
A[1048774] = 52
A[1048775] = 53
A[1048776] = 54
A[1048777] = 55
A[1048778] = 56
A[1048779] = 57
A[1048780] = 43
A[1048781] = 47
A[1048782] = 0
local D, E, F, G, H, I, J, K, L
function D()
  error("Unreachable code reached..", 2)
end
function E(M, N, O)
  local P = 0
  local Q = 0
  local R = 0
  local S = 0
  local T = 0
  local U = 0
  local V = 0
  local W = imports.ccm1__warp_from_value_to_uint8ptr(M)
  P = W
  local X = imports.ccm1__warp_from_value_to_uint8ptr(N)
  Q = X
 if checkCondition(((O == 0) and 1 or 0)) then 
	::YStart::
 storeMem(A, ASize, Q, 0, 8)
   local Z = imports.ccm1__warp_from_uint8ptr_to_value(Q)
  if true then return Z end
	::YFinish::
  end
  R = 0
  S = 0
  T = 0
  U = 0
 do 
	::BAStart::
  V = (readMem(A, ASize, (T + P), 8,3))
 do 
	::BBStart::
 do 
	::BCStart::
 do 
	::BDStart::
 do 
	::BEStart::
 do 
	::BFStart::
	local eax=U
	local branch_tab = ffi.new('int[3]', {0,1,2})
	if (eax < 3) then
	eax=branch_tab[eax];
	 if eax == 2 then
		 goto BBFinish
	 end
	 if eax == 1 then
		 goto BCFinish
	 end
	 if eax == 0 then
		 goto BDFinish
	 end
	else
		 goto BAFinish
	end
	::BFFinish::
  end
  V = V
 storeMem(A, ASize, (S + Q), (readMem(A, ASize, (bit.rshift(V, 2))+1048718, 8,3)), 8)
   S = (S + 1)
  U = 1
 goto BBFinish
	::BEFinish::
  end
  V = V
 storeMem(A, ASize, (S + Q), (readMem(A, ASize, (bit.bor((bit.rshift(V, 4)), (bit.band((bit.lshift(R, 4)), 48))))+1048718, 8,3)), 8)
   S = (S + 1)
  U = 2
 goto BBFinish
	::BDFinish::
  end
  V = V
 storeMem(A, ASize, (S + Q), (readMem(A, ASize, (bit.bor((bit.rshift(V, 6)), (bit.band((bit.lshift(R, 2)), 60))))+1048718, 8,3)), 8)
  storeMem(A, ASize, (S + Q)+1, (readMem(A, ASize, (bit.band(V, 63))+1048718, 8,3)), 8)
   S = (S + 2)
  U = 0
 goto BBFinish
	::BCFinish::
  end
  V = V
	::BBFinish::
  end
  T = (T + 1)
 if checkCondition((((T + 1) == O) and 1 or 0)) then 
	::BGStart::
  T = (S + Q)
 do 
	::BHStart::
 do 
	::BIStart::
 do 
	::BJStart::
	local eax=(U - 1)
	local branch_tab = ffi.new('int[2]', {0,1})
	if (eax < 2) then
	eax=branch_tab[eax];
	 if eax == 1 then
		 goto BIFinish
	 end
	 if eax == 0 then
		 goto BJFinish
	 end
	else
		 goto BHFinish
	end
	::BJFinish::
  end
 storeMem(A, ASize, T, (readMem(A, ASize, (bit.band((bit.lshift(V, 4)), 48))+1048718, 8,3)), 8)
  storeMem(A, ASize, (S + Q)+1, 61, 8)
  storeMem(A, ASize, (S + Q)+2, 61, 8)
  storeMem(A, ASize, (S + Q)+3, 0, 8)
   local BK = imports.ccm1__warp_from_uint8ptr_to_value(Q)
  if true then return BK end
	::BIFinish::
  end
 storeMem(A, ASize, T, (readMem(A, ASize, (bit.band((bit.lshift(V, 2)), 60))+1048718, 8,3)), 8)
  storeMem(A, ASize, (S + Q)+1, 61, 8)
  storeMem(A, ASize, (S + Q)+2, 0, 8)
   local BL = imports.ccm1__warp_from_uint8ptr_to_value(Q)
  if true then return BL end
	::BHFinish::
  end
 storeMem(A, ASize, (S + Q), 0, 8)
   local BM = imports.ccm1__warp_from_uint8ptr_to_value(Q)
  if true then return BM end
	::BGFinish::
  end
  R = V
 goto BAStart
	::BAFinish::
  end
  return 0
end
function F(BN)
  local BO = 0
  local BP = 0
  local BQ = 0
  BP = (BN + -1)
 if checkCondition((((BN + -1) < 2) and 1 or 0)) then 
	::BRStart::
  if true then return 1 end
	::BRFinish::
  end
  BQ = 1
  BO = BN
 do 
	::BSStart::
  local BT = F(BP)
  BQ = (BT + BQ)
  BP = (BO + -3)
 if checkCondition((((BO + -3) < 2) and 1 or 0)) then 
	::BUStart::
  if true then return BQ end
	::BUFinish::
  end
  BO = (BO + -2)
 goto BSStart
	::BSFinish::
  end
  return 0
end
function G()
  local BV = 0
  local BW = 0
  local BX = 0
  local BY = 0
  BV = B
  BY = (B + -256)
  B = (B + -256)
  local BZ = imports.ccm1__string_from_cstr_to_value(1048584)
  local CA = imports.ccm1__warp_from_uint8ptr_to_value(BY)
  BX = CA
  local CB = E(BZ, CA, 4)
  imports.ccm1__string_log(BX)
  B = BV
  return 0
end
function H(CC, CD, CE)
  local CF = 0
  local CG = 0
  local CH = 0
  local CI = 0
  local CJ = 0
  local CK = 0
  local CL = imports.ccm1__warp_from_value_to_uint8ptr(CC)
  CF = CL
  local CM = imports.ccm1__warp_from_value_to_uint8ptr(CD)
  CG = CM
 if checkCondition((bit.band(CE, 3))) then 
	::CNStart::
  if true then return 0 end
	::CNFinish::
  end
 if checkCondition(CE) then 
	::COStart::
  CH = 0
  CI = 0
 do 
	::CPStart::
  CJ = (readMem(A, ASize, (CI + CF), 8,3))
 if checkCondition((((readMem(A, ASize, (CI + CF), 8,3)) ~= 61) and 1 or 0)) then 
	::CQStart::
 if checkCondition((((bit.band((CJ + 213), 255)) > 79) and 1 or 0)) then 
	::CRStart::
  if true then return 0 end
	::CRFinish::
  end
  CJ = (readMem(A, ASize, CJ+1048590, 8,3))
 if checkCondition((((readMem(A, ASize, CJ+1048590, 8,3)) == 255) and 1 or 0)) then 
	::CSStart::
  if true then return 0 end
	::CSFinish::
  end
 do 
	::CTStart::
 do 
	::CUStart::
 do 
	::CVStart::
 do 
	::CWStart::
 do 
	::CXStart::
	local eax=(bit.band(CI, 3))
	local branch_tab = ffi.new('int[4]', {0,1,2,3})
	if (eax < 4) then
	eax=branch_tab[eax];
	 if eax == 3 then
		 goto CTFinish
	 end
	 if eax == 2 then
		 goto CUFinish
	 end
	 if eax == 1 then
		 goto CVFinish
	 end
	 if eax == 0 then
		 goto CWFinish
	 end
	else
		 goto CPFinish
	end
	::CXFinish::
  end
 storeMem(A, ASize, (CH + CG), (bit.lshift(CJ, 2)), 8)
  goto CTFinish
	::CWFinish::
  end
  CK = (CH + CG)
 storeMem(A, ASize, (CH + CG), (bit.bor((readMem(A, ASize, CK, 8,3)), (bit.band((bit.rshift(CJ, 4)), 3)))), 8)
   CH = (CH + 1)
 storeMem(A, ASize, ((CH + 1) + CG), (bit.lshift(CJ, 4)), 8)
  goto CTFinish
	::CVFinish::
  end
  CK = (CH + CG)
 storeMem(A, ASize, (CH + CG), (bit.bor((readMem(A, ASize, CK, 8,3)), (bit.band((bit.rshift(CJ, 2)), 15)))), 8)
   CH = (CH + 1)
 storeMem(A, ASize, ((CH + 1) + CG), (bit.lshift(CJ, 6)), 8)
  goto CTFinish
	::CUFinish::
  end
  CK = (CH + CG)
 storeMem(A, ASize, (CH + CG), (bit.bor((readMem(A, ASize, CK, 8,3)), CJ)), 8)
   CH = (CH + 1)
 goto CTFinish
	::CTFinish::
  end
  CI = (CI + 1)
  if checkCondition((((CI + 1) < CE) and 1 or 0)) then
      goto CPStart
  end
	::CQFinish::
  end
	::CPFinish::
  end
  else
  CH = 0
	::COFinish::
  end
 storeMem(A, ASize, (CH + CG), 0, 8)
   local CY = imports.ccm1__warp_from_uint8ptr_to_value(CM)
  return CY
end
function I(CZ, DA)
  return ((checkCondition(((CZ > DA) and 1 or 0)) and CZ) or (DA) * 100)
end
function J(DB, DC)
  return (checkCondition(((DB > DC) and 1 or 0)) and DB) or (DC)
end
function K(DD, DE)
  return (checkCondition(((DD > DE) and 1 or 0)) and DD) or (DE)
end
function L(DF, DG)
  return (checkCondition(((DF > DG) and 1 or 0)) and DF) or (DG)
end
exportTable.main = G
exportTable.base64_encode = E
exportTable.test_max2 = K
exportTable.test_max1 = L
exportTable.memory = A
exportTable.base64_decode = H
exportTable.test_max3 = J
exportTable.test_max4 = I
exportTable.fab = F
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
