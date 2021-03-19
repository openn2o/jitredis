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
A[1048600] = 49
A[1048601] = 54
A[1048602] = 51
A[1048603] = 56
A[1048604] = 51
A[1048605] = 49
A[1048606] = 54
A[1048607] = 51
A[1048608] = 56
A[1048609] = 51
A[1048610] = 49
A[1048611] = 54
A[1048612] = 51
A[1048613] = 56
A[1048614] = 51
A[1048615] = 49
A[1048616] = 54
A[1048617] = 51
A[1048618] = 56
A[1048619] = 51
A[1048620] = 49
A[1048621] = 54
A[1048622] = 51
A[1048623] = 56
A[1048624] = 51
A[1048625] = 49
A[1048626] = 54
A[1048627] = 51
A[1048628] = 56
A[1048629] = 51
A[1048630] = 49
A[1048631] = 54
A[1048632] = 51
A[1048633] = 56
A[1048634] = 51
A[1048635] = 49
A[1048636] = 54
A[1048637] = 51
A[1048638] = 56
A[1048639] = 51
A[1048640] = 49
A[1048641] = 54
A[1048642] = 51
A[1048643] = 56
A[1048644] = 51
A[1048645] = 49
A[1048646] = 54
A[1048647] = 51
A[1048648] = 56
A[1048649] = 51
A[1048650] = 49
A[1048651] = 54
A[1048652] = 51
A[1048653] = 56
A[1048654] = 51
A[1048655] = 49
A[1048656] = 54
A[1048657] = 51
A[1048658] = 56
A[1048659] = 51
A[1048660] = 49
A[1048661] = 54
A[1048662] = 51
A[1048663] = 56
A[1048664] = 51
A[1048665] = 49
A[1048666] = 54
A[1048667] = 51
A[1048668] = 56
A[1048669] = 51
A[1048670] = 49
A[1048671] = 54
A[1048672] = 51
A[1048673] = 56
A[1048674] = 51
A[1048675] = 49
A[1048676] = 54
A[1048677] = 51
A[1048678] = 56
A[1048679] = 51
A[1048680] = 49
A[1048681] = 54
A[1048682] = 51
A[1048683] = 56
A[1048684] = 51
A[1048685] = 49
A[1048686] = 54
A[1048687] = 51
A[1048688] = 56
A[1048689] = 51
A[1048690] = 49
A[1048691] = 54
A[1048692] = 51
A[1048693] = 56
A[1048694] = 51
A[1048695] = 49
A[1048696] = 54
A[1048697] = 51
A[1048698] = 56
A[1048699] = 51
A[1048700] = 49
A[1048701] = 54
A[1048702] = 51
A[1048703] = 56
A[1048704] = 51
A[1048705] = 56
A[1048706] = 48
A[1048707] = 54
A[1048708] = 51
A[1048709] = 49
A[1048710] = 54
A[1048711] = 51
A[1048712] = 56
A[1048713] = 51
A[1048714] = 56
A[1048715] = 49
A[1048716] = 57
A[1048717] = 49
A[1048718] = 53
A[1048719] = 50
A[1048720] = 53
A[1048721] = 51
A[1048722] = 53
A[1048723] = 52
A[1048724] = 53
A[1048725] = 53
A[1048726] = 53
A[1048727] = 54
A[1048728] = 53
A[1048729] = 55
A[1048730] = 53
A[1048731] = 56
A[1048732] = 53
A[1048733] = 57
A[1048734] = 54
A[1048735] = 48
A[1048736] = 54
A[1048737] = 49
A[1048738] = 49
A[1048739] = 54
A[1048740] = 51
A[1048741] = 56
A[1048742] = 51
A[1048743] = 49
A[1048744] = 54
A[1048745] = 51
A[1048746] = 56
A[1048747] = 51
A[1048748] = 49
A[1048749] = 54
A[1048750] = 51
A[1048751] = 56
A[1048752] = 51
A[1048753] = 49
A[1048754] = 50
A[1048755] = 55
A[1048756] = 49
A[1048757] = 50
A[1048758] = 51
A[1048759] = 52
A[1048760] = 53
A[1048761] = 54
A[1048762] = 55
A[1048763] = 56
A[1048764] = 57
A[1048765] = 49
A[1048766] = 48
A[1048767] = 49
A[1048768] = 49
A[1048769] = 49
A[1048770] = 50
A[1048771] = 49
A[1048772] = 51
A[1048773] = 49
A[1048774] = 52
A[1048775] = 49
A[1048776] = 53
A[1048777] = 49
A[1048778] = 54
A[1048779] = 49
A[1048780] = 55
A[1048781] = 49
A[1048782] = 56
A[1048783] = 49
A[1048784] = 57
A[1048785] = 50
A[1048786] = 48
A[1048787] = 50
A[1048788] = 49
A[1048789] = 50
A[1048790] = 50
A[1048791] = 50
A[1048792] = 51
A[1048793] = 50
A[1048794] = 52
A[1048795] = 50
A[1048796] = 53
A[1048797] = 49
A[1048798] = 54
A[1048799] = 51
A[1048800] = 56
A[1048801] = 51
A[1048802] = 49
A[1048803] = 54
A[1048804] = 51
A[1048805] = 56
A[1048806] = 51
A[1048807] = 49
A[1048808] = 54
A[1048809] = 51
A[1048810] = 56
A[1048811] = 51
A[1048812] = 50
A[1048813] = 54
A[1048814] = 50
A[1048815] = 55
A[1048816] = 50
A[1048817] = 56
A[1048818] = 50
A[1048819] = 57
A[1048820] = 51
A[1048821] = 48
A[1048822] = 51
A[1048823] = 49
A[1048824] = 51
A[1048825] = 50
A[1048826] = 51
A[1048827] = 51
A[1048828] = 51
A[1048829] = 52
A[1048830] = 51
A[1048831] = 53
A[1048832] = 51
A[1048833] = 54
A[1048834] = 51
A[1048835] = 55
A[1048836] = 51
A[1048837] = 56
A[1048838] = 51
A[1048839] = 57
A[1048840] = 52
A[1048841] = 48
A[1048842] = 52
A[1048843] = 49
A[1048844] = 52
A[1048845] = 50
A[1048846] = 52
A[1048847] = 51
A[1048848] = 52
A[1048849] = 52
A[1048850] = 52
A[1048851] = 53
A[1048852] = 52
A[1048853] = 54
A[1048854] = 52
A[1048855] = 55
A[1048856] = 52
A[1048857] = 56
A[1048858] = 52
A[1048859] = 57
A[1048860] = 53
A[1048861] = 48
A[1048862] = 53
A[1048863] = 49
A[1048864] = 49
A[1048865] = 54
A[1048866] = 51
A[1048867] = 56
A[1048868] = 51
A[1048869] = 49
A[1048870] = 54
A[1048871] = 51
A[1048872] = 56
A[1048873] = 51
A[1048874] = 56
A[1048875] = 52
A[1048876] = 52
A[1048877] = 55
A[1048878] = 54
A[1048879] = 54
A[1048880] = 54
A[1048881] = 55
A[1048882] = 54
A[1048883] = 56
A[1048884] = 54
A[1048885] = 57
A[1048886] = 55
A[1048887] = 48
A[1048888] = 55
A[1048889] = 49
A[1048890] = 55
A[1048891] = 50
A[1048892] = 55
A[1048893] = 51
A[1048894] = 55
A[1048895] = 52
A[1048896] = 55
A[1048897] = 53
A[1048898] = 55
A[1048899] = 54
A[1048900] = 55
A[1048901] = 55
A[1048902] = 55
A[1048903] = 56
A[1048904] = 55
A[1048905] = 57
A[1048906] = 56
A[1048907] = 48
A[1048908] = 56
A[1048909] = 49
A[1048910] = 56
A[1048911] = 50
A[1048912] = 56
A[1048913] = 51
A[1048914] = 56
A[1048915] = 52
A[1048916] = 56
A[1048917] = 53
A[1048918] = 56
A[1048919] = 54
A[1048920] = 56
A[1048921] = 55
A[1048922] = 56
A[1048923] = 56
A[1048924] = 56
A[1048925] = 57
A[1048926] = 57
A[1048927] = 48
A[1048928] = 57
A[1048929] = 55
A[1048930] = 57
A[1048931] = 56
A[1048932] = 57
A[1048933] = 57
A[1048934] = 49
A[1048935] = 48
A[1048936] = 48
A[1048937] = 49
A[1048938] = 48
A[1048939] = 49
A[1048940] = 49
A[1048941] = 48
A[1048942] = 50
A[1048943] = 49
A[1048944] = 48
A[1048945] = 51
A[1048946] = 49
A[1048947] = 48
A[1048948] = 52
A[1048949] = 49
A[1048950] = 48
A[1048951] = 53
A[1048952] = 49
A[1048953] = 48
A[1048954] = 54
A[1048955] = 49
A[1048956] = 48
A[1048957] = 55
A[1048958] = 49
A[1048959] = 48
A[1048960] = 56
A[1048961] = 49
A[1048962] = 48
A[1048963] = 57
A[1048964] = 49
A[1048965] = 49
A[1048966] = 48
A[1048967] = 49
A[1048968] = 49
A[1048969] = 49
A[1048970] = 49
A[1048971] = 49
A[1048972] = 50
A[1048973] = 49
A[1048974] = 49
A[1048975] = 51
A[1048976] = 49
A[1048977] = 49
A[1048978] = 52
A[1048979] = 49
A[1048980] = 49
A[1048981] = 53
A[1048982] = 49
A[1048983] = 49
A[1048984] = 54
A[1048985] = 49
A[1048986] = 49
A[1048987] = 55
A[1048988] = 49
A[1048989] = 49
A[1048990] = 56
A[1048991] = 49
A[1048992] = 49
A[1048993] = 57
A[1048994] = 49
A[1048995] = 50
A[1048996] = 48
A[1048997] = 49
A[1048998] = 50
A[1048999] = 49
A[1049000] = 49
A[1049001] = 50
A[1049002] = 50
A[1049003] = 52
A[1049004] = 56
A[1049005] = 52
A[1049006] = 57
A[1049007] = 53
A[1049008] = 48
A[1049009] = 53
A[1049010] = 49
A[1049011] = 53
A[1049012] = 50
A[1049013] = 53
A[1049014] = 51
A[1049015] = 53
A[1049016] = 52
A[1049017] = 53
A[1049018] = 53
A[1049019] = 53
A[1049020] = 54
A[1049021] = 53
A[1049022] = 55
A[1049023] = 52
A[1049024] = 51
A[1049025] = 52
A[1049026] = 55
A[1049027] = 49
A[1049028] = 49
A[1049029] = 49
A[1049030] = 49
A[1049031] = 49
A[1049032] = 49
A[1049033] = 49
A[1049034] = 49
A[1049035] = 49
A[1049036] = 49
A[1049037] = 49
A[1049038] = 49
A[1049039] = 49
A[1049040] = 49
A[1049041] = 49
A[1049042] = 49
A[1049043] = 49
A[1049044] = 49
A[1049045] = 49
A[1049046] = 49
A[1049047] = 49
A[1049048] = 49
A[1049049] = 49
A[1049050] = 49
A[1049051] = 49
A[1049052] = 49
A[1049053] = 49
A[1049054] = 49
A[1049055] = 49
A[1049056] = 49
A[1049057] = 49
A[1049058] = 49
A[1049059] = 49
A[1049060] = 49
A[1049061] = 0
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
  V = (readMem(A, ASize, (T + P), 8))
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
 storeMem(A, ASize, (S + Q), (readMem(A, ASize, (bit.rshift(V, 2))+1048718, 8)), 8)
   S = (S + 1)
  U = 1
 goto BBFinish
	::BEFinish::
  end
  V = V
 storeMem(A, ASize, (S + Q), (readMem(A, ASize, (bit.bor((bit.rshift(V, 4)), (bit.band((bit.lshift(R, 4)), 48))))+1048718, 8)), 8)
   S = (S + 1)
  U = 2
 goto BBFinish
	::BDFinish::
  end
  V = V
 storeMem(A, ASize, (S + Q), (readMem(A, ASize, (bit.bor((bit.rshift(V, 6)), (bit.band((bit.lshift(R, 2)), 60))))+1048718, 8)), 8)
  storeMem(A, ASize, (S + Q)+1, (readMem(A, ASize, (bit.band(V, 63))+1048718, 8)), 8)
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
 storeMem(A, ASize, T, (readMem(A, ASize, (bit.band((bit.lshift(V, 4)), 48))+1048718, 8)), 8)
  storeMem(A, ASize, (S + Q)+1, 61, 8)
  storeMem(A, ASize, (S + Q)+2, 61, 8)
  storeMem(A, ASize, (S + Q)+3, 0, 8)
   local BK = imports.ccm1__warp_from_uint8ptr_to_value(Q)
  if true then return BK end
	::BIFinish::
  end
 storeMem(A, ASize, T, (readMem(A, ASize, (bit.band((bit.lshift(V, 2)), 60))+1048718, 8)), 8)
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
  BY = (B + -16)
  B = (B + -16)
  BY = (BY + 6)
  BW = (BY + 6)
 storeMem(A, ASize, (BY + 6), 1, 8)
  storeMem(A, ASize, BY+1, 2, 8)
  storeMem(A, ASize, BY+2, 3, 8)
  storeMem(A, ASize, BY+3, 4, 8)
  storeMem(A, ASize, BY+4, 5, 8)
  storeMem(A, ASize, BY+5, 6, 8)
  storeMem(A, ASize, BY+6, 7, 8)
  storeMem(A, ASize, BY+7, 8, 8)
  storeMem(A, ASize, BY+8, 9, 8)
  storeMem(A, ASize, BY+9, 10, 8)
   local BZ = imports.ccm1__string_from_cstr_to_value(1048584)
  local CA = imports.ccm1__warp_from_uint8ptr_to_value(BW)
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
  CJ = (readMem(A, ASize, (CI + CF), 8))
 if checkCondition((((readMem(A, ASize, (CI + CF), 8)) ~= 61) and 1 or 0)) then 
	::CQStart::
 if checkCondition((((bit.band((CJ + 213), 255)) > 79) and 1 or 0)) then 
	::CRStart::
  if true then return 0 end
	::CRFinish::
  end
  CJ = (readMem(A, ASize, CJ+1048590, 8))
 if checkCondition((((readMem(A, ASize, CJ+1048590, 8)) == 255) and 1 or 0)) then 
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
 storeMem(A, ASize, (CH + CG), (bit.bor((readMem(A, ASize, CK, 8)), (bit.band((bit.rshift(CJ, 4)), 3)))), 8)
   CH = (CH + 1)
 storeMem(A, ASize, ((CH + 1) + CG), (bit.lshift(CJ, 4)), 8)
  goto CTFinish
	::CVFinish::
  end
  CK = (CH + CG)
 storeMem(A, ASize, (CH + CG), (bit.bor((readMem(A, ASize, CK, 8)), (bit.band((bit.rshift(CJ, 2)), 15)))), 8)
   CH = (CH + 1)
 storeMem(A, ASize, ((CH + 1) + CG), (bit.lshift(CJ, 6)), 8)
  goto CTFinish
	::CUFinish::
  end
  CK = (CH + CG)
 storeMem(A, ASize, (CH + CG), (bit.bor((readMem(A, ASize, CK, 8)), CJ)), 8)
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
exportTable.test_max1 = L
exportTable.base64_encode = E
exportTable.test_max3 = J
exportTable.test_max2 = K
exportTable.fab = F
exportTable.base64_decode = H
exportTable.test_max4 = I
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
