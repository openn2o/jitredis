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
A[1048600] = 52
A[1048601] = 56
A[1048602] = 52
A[1048603] = 56
A[1048604] = 52
A[1048605] = 56
A[1048606] = 52
A[1048607] = 56
A[1048608] = 52
A[1048609] = 56
A[1048610] = 52
A[1048611] = 56
A[1048612] = 52
A[1048613] = 56
A[1048614] = 52
A[1048615] = 56
A[1048616] = 52
A[1048617] = 56
A[1048618] = 52
A[1048619] = 56
A[1048620] = 52
A[1048621] = 56
A[1048622] = 52
A[1048623] = 56
A[1048624] = 52
A[1048625] = 56
A[1048626] = 52
A[1048627] = 56
A[1048628] = 52
A[1048629] = 56
A[1048630] = 52
A[1048631] = 56
A[1048632] = 52
A[1048633] = 56
A[1048634] = 52
A[1048635] = 56
A[1048636] = 52
A[1048637] = 56
A[1048638] = 52
A[1048639] = 56
A[1048640] = 52
A[1048641] = 56
A[1048642] = 52
A[1048643] = 56
A[1048644] = 52
A[1048645] = 56
A[1048646] = 52
A[1048647] = 56
A[1048648] = 52
A[1048649] = 56
A[1048650] = 52
A[1048651] = 56
A[1048652] = 52
A[1048653] = 56
A[1048654] = 52
A[1048655] = 56
A[1048656] = 48
A[1048657] = 49
A[1048658] = 54
A[1048659] = 51
A[1048660] = 56
A[1048661] = 51
A[1048662] = 49
A[1048663] = 54
A[1048664] = 51
A[1048665] = 56
A[1048666] = 51
A[1048667] = 49
A[1048668] = 54
A[1048669] = 51
A[1048670] = 56
A[1048671] = 51
A[1048672] = 49
A[1048673] = 54
A[1048674] = 51
A[1048675] = 56
A[1048676] = 51
A[1048677] = 49
A[1048678] = 54
A[1048679] = 51
A[1048680] = 56
A[1048681] = 51
A[1048682] = 49
A[1048683] = 54
A[1048684] = 51
A[1048685] = 56
A[1048686] = 51
A[1048687] = 49
A[1048688] = 54
A[1048689] = 51
A[1048690] = 56
A[1048691] = 51
A[1048692] = 49
A[1048693] = 54
A[1048694] = 51
A[1048695] = 56
A[1048696] = 51
A[1048697] = 49
A[1048698] = 54
A[1048699] = 51
A[1048700] = 56
A[1048701] = 51
A[1048702] = 49
A[1048703] = 54
A[1048704] = 51
A[1048705] = 56
A[1048706] = 51
A[1048707] = 49
A[1048708] = 54
A[1048709] = 51
A[1048710] = 56
A[1048711] = 51
A[1048712] = 49
A[1048713] = 54
A[1048714] = 51
A[1048715] = 56
A[1048716] = 51
A[1048717] = 49
A[1048718] = 54
A[1048719] = 51
A[1048720] = 56
A[1048721] = 51
A[1048722] = 49
A[1048723] = 54
A[1048724] = 51
A[1048725] = 56
A[1048726] = 51
A[1048727] = 49
A[1048728] = 54
A[1048729] = 51
A[1048730] = 56
A[1048731] = 51
A[1048732] = 49
A[1048733] = 54
A[1048734] = 51
A[1048735] = 56
A[1048736] = 51
A[1048737] = 49
A[1048738] = 54
A[1048739] = 51
A[1048740] = 56
A[1048741] = 51
A[1048742] = 49
A[1048743] = 54
A[1048744] = 51
A[1048745] = 56
A[1048746] = 51
A[1048747] = 49
A[1048748] = 54
A[1048749] = 51
A[1048750] = 56
A[1048751] = 51
A[1048752] = 49
A[1048753] = 54
A[1048754] = 51
A[1048755] = 56
A[1048756] = 51
A[1048757] = 49
A[1048758] = 54
A[1048759] = 51
A[1048760] = 56
A[1048761] = 51
A[1048762] = 56
A[1048763] = 48
A[1048764] = 54
A[1048765] = 51
A[1048766] = 49
A[1048767] = 54
A[1048768] = 51
A[1048769] = 56
A[1048770] = 51
A[1048771] = 56
A[1048772] = 49
A[1048773] = 57
A[1048774] = 49
A[1048775] = 53
A[1048776] = 50
A[1048777] = 53
A[1048778] = 51
A[1048779] = 53
A[1048780] = 52
A[1048781] = 53
A[1048782] = 53
A[1048783] = 53
A[1048784] = 54
A[1048785] = 53
A[1048786] = 55
A[1048787] = 53
A[1048788] = 56
A[1048789] = 53
A[1048790] = 57
A[1048791] = 54
A[1048792] = 48
A[1048793] = 54
A[1048794] = 49
A[1048795] = 49
A[1048796] = 54
A[1048797] = 51
A[1048798] = 56
A[1048799] = 51
A[1048800] = 49
A[1048801] = 54
A[1048802] = 51
A[1048803] = 56
A[1048804] = 51
A[1048805] = 49
A[1048806] = 54
A[1048807] = 51
A[1048808] = 56
A[1048809] = 51
A[1048810] = 49
A[1048811] = 50
A[1048812] = 55
A[1048813] = 49
A[1048814] = 50
A[1048815] = 51
A[1048816] = 52
A[1048817] = 53
A[1048818] = 54
A[1048819] = 55
A[1048820] = 56
A[1048821] = 57
A[1048822] = 49
A[1048823] = 48
A[1048824] = 49
A[1048825] = 49
A[1048826] = 49
A[1048827] = 50
A[1048828] = 49
A[1048829] = 51
A[1048830] = 49
A[1048831] = 52
A[1048832] = 49
A[1048833] = 53
A[1048834] = 49
A[1048835] = 54
A[1048836] = 49
A[1048837] = 55
A[1048838] = 49
A[1048839] = 56
A[1048840] = 49
A[1048841] = 57
A[1048842] = 50
A[1048843] = 48
A[1048844] = 50
A[1048845] = 49
A[1048846] = 50
A[1048847] = 50
A[1048848] = 50
A[1048849] = 51
A[1048850] = 50
A[1048851] = 52
A[1048852] = 50
A[1048853] = 53
A[1048854] = 49
A[1048855] = 54
A[1048856] = 51
A[1048857] = 56
A[1048858] = 51
A[1048859] = 49
A[1048860] = 54
A[1048861] = 51
A[1048862] = 56
A[1048863] = 51
A[1048864] = 49
A[1048865] = 54
A[1048866] = 51
A[1048867] = 56
A[1048868] = 51
A[1048869] = 50
A[1048870] = 54
A[1048871] = 50
A[1048872] = 55
A[1048873] = 50
A[1048874] = 56
A[1048875] = 50
A[1048876] = 57
A[1048877] = 51
A[1048878] = 48
A[1048879] = 51
A[1048880] = 49
A[1048881] = 51
A[1048882] = 50
A[1048883] = 51
A[1048884] = 51
A[1048885] = 51
A[1048886] = 52
A[1048887] = 51
A[1048888] = 53
A[1048889] = 51
A[1048890] = 54
A[1048891] = 51
A[1048892] = 55
A[1048893] = 51
A[1048894] = 56
A[1048895] = 51
A[1048896] = 57
A[1048897] = 52
A[1048898] = 48
A[1048899] = 52
A[1048900] = 49
A[1048901] = 52
A[1048902] = 50
A[1048903] = 52
A[1048904] = 51
A[1048905] = 52
A[1048906] = 52
A[1048907] = 52
A[1048908] = 53
A[1048909] = 52
A[1048910] = 54
A[1048911] = 52
A[1048912] = 55
A[1048913] = 52
A[1048914] = 56
A[1048915] = 52
A[1048916] = 57
A[1048917] = 53
A[1048918] = 48
A[1048919] = 53
A[1048920] = 49
A[1048921] = 49
A[1048922] = 54
A[1048923] = 51
A[1048924] = 56
A[1048925] = 51
A[1048926] = 49
A[1048927] = 54
A[1048928] = 51
A[1048929] = 56
A[1048930] = 51
A[1048931] = 56
A[1048932] = 52
A[1048933] = 52
A[1048934] = 55
A[1048935] = 54
A[1048936] = 54
A[1048937] = 54
A[1048938] = 55
A[1048939] = 54
A[1048940] = 56
A[1048941] = 54
A[1048942] = 57
A[1048943] = 55
A[1048944] = 48
A[1048945] = 55
A[1048946] = 49
A[1048947] = 55
A[1048948] = 50
A[1048949] = 55
A[1048950] = 51
A[1048951] = 55
A[1048952] = 52
A[1048953] = 55
A[1048954] = 53
A[1048955] = 55
A[1048956] = 54
A[1048957] = 55
A[1048958] = 55
A[1048959] = 55
A[1048960] = 56
A[1048961] = 55
A[1048962] = 57
A[1048963] = 56
A[1048964] = 48
A[1048965] = 56
A[1048966] = 49
A[1048967] = 56
A[1048968] = 50
A[1048969] = 56
A[1048970] = 51
A[1048971] = 56
A[1048972] = 52
A[1048973] = 56
A[1048974] = 53
A[1048975] = 56
A[1048976] = 54
A[1048977] = 56
A[1048978] = 55
A[1048979] = 56
A[1048980] = 56
A[1048981] = 56
A[1048982] = 57
A[1048983] = 57
A[1048984] = 48
A[1048985] = 57
A[1048986] = 55
A[1048987] = 57
A[1048988] = 56
A[1048989] = 57
A[1048990] = 57
A[1048991] = 49
A[1048992] = 48
A[1048993] = 48
A[1048994] = 49
A[1048995] = 48
A[1048996] = 49
A[1048997] = 49
A[1048998] = 48
A[1048999] = 50
A[1049000] = 49
A[1049001] = 48
A[1049002] = 51
A[1049003] = 49
A[1049004] = 48
A[1049005] = 52
A[1049006] = 49
A[1049007] = 48
A[1049008] = 53
A[1049009] = 49
A[1049010] = 48
A[1049011] = 54
A[1049012] = 49
A[1049013] = 48
A[1049014] = 55
A[1049015] = 49
A[1049016] = 48
A[1049017] = 56
A[1049018] = 49
A[1049019] = 48
A[1049020] = 57
A[1049021] = 49
A[1049022] = 49
A[1049023] = 48
A[1049024] = 49
A[1049025] = 49
A[1049026] = 49
A[1049027] = 49
A[1049028] = 49
A[1049029] = 50
A[1049030] = 49
A[1049031] = 49
A[1049032] = 51
A[1049033] = 49
A[1049034] = 49
A[1049035] = 52
A[1049036] = 49
A[1049037] = 49
A[1049038] = 53
A[1049039] = 49
A[1049040] = 49
A[1049041] = 54
A[1049042] = 49
A[1049043] = 49
A[1049044] = 55
A[1049045] = 49
A[1049046] = 49
A[1049047] = 56
A[1049048] = 49
A[1049049] = 49
A[1049050] = 57
A[1049051] = 49
A[1049052] = 50
A[1049053] = 48
A[1049054] = 49
A[1049055] = 50
A[1049056] = 49
A[1049057] = 49
A[1049058] = 50
A[1049059] = 50
A[1049060] = 52
A[1049061] = 56
A[1049062] = 52
A[1049063] = 57
A[1049064] = 53
A[1049065] = 48
A[1049066] = 53
A[1049067] = 49
A[1049068] = 53
A[1049069] = 50
A[1049070] = 53
A[1049071] = 51
A[1049072] = 53
A[1049073] = 52
A[1049074] = 53
A[1049075] = 53
A[1049076] = 53
A[1049077] = 54
A[1049078] = 53
A[1049079] = 55
A[1049080] = 52
A[1049081] = 51
A[1049082] = 52
A[1049083] = 55
A[1049084] = 49
A[1049085] = 49
A[1049086] = 49
A[1049087] = 49
A[1049088] = 49
A[1049089] = 49
A[1049090] = 49
A[1049091] = 49
A[1049092] = 49
A[1049093] = 49
A[1049094] = 49
A[1049095] = 49
A[1049096] = 49
A[1049097] = 49
A[1049098] = 49
A[1049099] = 49
A[1049100] = 49
A[1049101] = 49
A[1049102] = 49
A[1049103] = 49
A[1049104] = 49
A[1049105] = 49
A[1049106] = 49
A[1049107] = 49
A[1049108] = 49
A[1049109] = 49
A[1049110] = 49
A[1049111] = 49
A[1049112] = 49
A[1049113] = 49
A[1049114] = 49
A[1049115] = 49
A[1049116] = 49
A[1049117] = 49
A[1049118] = 0
local D, E, F, G
function D()
  error("Unreachable code reached..", 2)
end
function E(H, I, J)
  local K = 0
  local L = 0
  local M = 0
  local N = 0
  local O = 0
  local P = 0
  local Q = 0
  local R = imports.ccm1__warp_from_value_to_uint8ptr(H)
  K = R
  local S = imports.ccm1__warp_from_value_to_uint8ptr(I)
  L = S
 if checkCondition(((J == 0) and 1 or 0)) then 
	::TStart::
  storeMem(A, ASize, L, 0, 8)
  local U = imports.ccm1__warp_from_uint8ptr_to_value(L)
  if true then return U end
	::TFinish::
  end
  M = 0
  N = 0
  O = 0
  P = 0
 do 
	::VStart::
  Q = (readMem(A, ASize, (O + K), 8))
 do 
	::WStart::
 do 
	::XStart::
 do 
	::YStart::
 do 
	::ZStart::
 do 
	::BAStart::
	local eax=P
	local branch_tab = ffi.new('int[3]', {0,1,2})
	if (eax < 3) then
	eax=branch_tab[eax];
	 if eax == 2 then
		 goto WFinish
	 end
	 if eax == 1 then
		 goto XFinish
	 end
	 if eax == 0 then
		 goto YFinish
	 end
	else
		 goto VFinish
	end
	::BAFinish::
  end
  Q = Q
  storeMem(A, ASize, (N + L), (readMem(A, ASize, (bit.rshift(Q, 2)), 8)), 8)
  N = (N + 1)
  P = 1
 goto WFinish
	::ZFinish::
  end
  Q = Q
  storeMem(A, ASize, (N + L), (readMem(A, ASize, (bit.bor((bit.rshift(Q, 4)), (bit.band((bit.lshift(M, 4)), 48)))), 8)), 8)
  N = (N + 1)
  P = 2
 goto WFinish
	::YFinish::
  end
  Q = Q
  storeMem(A, ASize, (N + L), (readMem(A, ASize, (bit.bor((bit.rshift(Q, 6)), (bit.band((bit.lshift(M, 2)), 60)))), 8)), 8)
  storeMem(A, ASize, (N + L), (readMem(A, ASize, (bit.band(Q, 63)), 8)), 8)
  N = (N + 2)
  P = 0
 goto WFinish
	::XFinish::
  end
  Q = Q
	::WFinish::
  end
  O = (O + 1)
 if checkCondition((((O + 1) == J) and 1 or 0)) then 
	::BBStart::
  O = (N + L)
 do 
	::BCStart::
 do 
	::BDStart::
 do 
	::BEStart::
	local eax=(P - 1)
	local branch_tab = ffi.new('int[2]', {0,1})
	if (eax < 2) then
	eax=branch_tab[eax];
	 if eax == 1 then
		 goto BDFinish
	 end
	 if eax == 0 then
		 goto BEFinish
	 end
	else
		 goto BCFinish
	end
	::BEFinish::
  end
  storeMem(A, ASize, O, (readMem(A, ASize, (bit.band((bit.lshift(Q, 4)), 48)), 8)), 8)
  storeMem(A, ASize, (N + L), 61, 8)
  storeMem(A, ASize, (N + L), 61, 8)
  storeMem(A, ASize, (N + L), 0, 8)
  local BF = imports.ccm1__warp_from_uint8ptr_to_value(L)
  if true then return BF end
	::BDFinish::
  end
  storeMem(A, ASize, O, (readMem(A, ASize, (bit.band((bit.lshift(Q, 2)), 60)), 8)), 8)
  storeMem(A, ASize, (N + L), 61, 8)
  storeMem(A, ASize, (N + L), 0, 8)
  local BG = imports.ccm1__warp_from_uint8ptr_to_value(L)
  if true then return BG end
	::BCFinish::
  end
  storeMem(A, ASize, (N + L), 0, 8)
  local BH = imports.ccm1__warp_from_uint8ptr_to_value(L)
  if true then return BH end
	::BBFinish::
  end
  M = Q
 goto VStart
	::VFinish::
  end
  return 0
end
function F()
  local BI = 0
  local BJ = 0
  local BK = imports.ccm1__string_from_cstr_to_value(1048584)
  local BL = imports.ccm1__warp_from_uint8ptr_to_value(1048590)
  BJ = BL
  local BM = E(BK, BL, 4)
  imports.ccm1__string_log(BJ)
  return 0
end
function G(BN, BO, BP)
  local BQ = 0
  local BR = 0
  local BS = 0
  local BT = 0
  local BU = 0
  local BV = 0
  local BW = imports.ccm1__warp_from_value_to_uint8ptr(BN)
  BQ = BW
  local BX = imports.ccm1__warp_from_value_to_uint8ptr(BO)
  BR = BX
 if checkCondition((bit.band(BP, 3))) then 
	::BYStart::
  if true then return 0 end
	::BYFinish::
  end
 if checkCondition(BP) then 
	::BZStart::
  BS = 0
  BT = 0
 do 
	::CAStart::
  BU = (readMem(A, ASize, (BT + BQ), 8))
 if checkCondition((((readMem(A, ASize, (BT + BQ), 8)) ~= 61) and 1 or 0)) then 
	::CBStart::
 if checkCondition((((bit.band((BU + 213), 255)) > 79) and 1 or 0)) then 
	::CCStart::
  if true then return 0 end
	::CCFinish::
  end
  BU = (readMem(A, ASize, BU, 8))
 if checkCondition((((readMem(A, ASize, BU, 8)) == 255) and 1 or 0)) then 
	::CDStart::
  if true then return 0 end
	::CDFinish::
  end
 do 
	::CEStart::
 do 
	::CFStart::
 do 
	::CGStart::
 do 
	::CHStart::
 do 
	::CIStart::
	local eax=(bit.band(BT, 3))
	local branch_tab = ffi.new('int[4]', {0,1,2,3})
	if (eax < 4) then
	eax=branch_tab[eax];
	 if eax == 3 then
		 goto CEFinish
	 end
	 if eax == 2 then
		 goto CFFinish
	 end
	 if eax == 1 then
		 goto CGFinish
	 end
	 if eax == 0 then
		 goto CHFinish
	 end
	else
		 goto CAFinish
	end
	::CIFinish::
  end
  storeMem(A, ASize, (BS + BR), (bit.lshift(BU, 2)), 8)
 goto CEFinish
	::CHFinish::
  end
  BV = (BS + BR)
  storeMem(A, ASize, (BS + BR), (bit.bor((readMem(A, ASize, BV, 8)), (bit.band((bit.rshift(BU, 4)), 3)))), 8)
  BS = (BS + 1)
  storeMem(A, ASize, ((BS + 1) + BR), (bit.lshift(BU, 4)), 8)
 goto CEFinish
	::CGFinish::
  end
  BV = (BS + BR)
  storeMem(A, ASize, (BS + BR), (bit.bor((readMem(A, ASize, BV, 8)), (bit.band((bit.rshift(BU, 2)), 15)))), 8)
  BS = (BS + 1)
  storeMem(A, ASize, ((BS + 1) + BR), (bit.lshift(BU, 6)), 8)
 goto CEFinish
	::CFFinish::
  end
  BV = (BS + BR)
  storeMem(A, ASize, (BS + BR), (bit.bor((readMem(A, ASize, BV, 8)), BU)), 8)
  BS = (BS + 1)
 goto CEFinish
	::CEFinish::
  end
  BT = (BT + 1)
  if checkCondition((((BT + 1) < BP) and 1 or 0)) then
      goto CAStart
  end
	::CBFinish::
  end
	::CAFinish::
  end
  else
  BS = 0
	::BZFinish::
  end
  storeMem(A, ASize, (BS + BR), 0, 8)
  local CJ = imports.ccm1__warp_from_uint8ptr_to_value(BX)
  return CJ
end
exportTable.base64_decode = G
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
