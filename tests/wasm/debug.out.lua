local ccm1 = require("ccm1_string");
local imports = {ccm1__string_new = ccm1.ccm1__string_new
,ccm1__string_from_cstr_to_value = ccm1.ccm1__string_from_cstr_to_value
,ccm1__string_log = ccm1.ccm1__string_log
,ccm1__dynamic_string_new = ccm1.ccm1__dynamic_string_new
,ccm1__dynamic_string_append = ccm1.ccm1__dynamic_string_append
,ccm1__dynamic_string_log = ccm1.ccm1__dynamic_string_log
,ccm1__dynamic_string_join = ccm1.ccm1__dynamic_string_join
,MyValue__Ev = function () error('not link MyValue__Ev module') end
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
local C = 0
local D = 1049648
local E = 0
local F = 1049648
local G = -1
local H = 1048592
local I = 0
local J = 0
local K = {  }
A[1048592] = 8
A[1048593] = 0
A[1048594] = 16
A[1048595] = 0
A[1048596] = 8
A[1048597] = 0
A[1048598] = 16
A[1048599] = 0
A[1048600] = 16
A[1048601] = 0
A[1048602] = 16
A[1048603] = 0
A[1048604] = 16
A[1048605] = 0
A[1048606] = 16
A[1048607] = 0
A[1048608] = 24
A[1048609] = 0
A[1048610] = 16
A[1048611] = 0
A[1048612] = 24
A[1048613] = 0
A[1048614] = 16
A[1048615] = 0
A[1048616] = 32
A[1048617] = 0
A[1048618] = 16
A[1048619] = 0
A[1048620] = 32
A[1048621] = 0
A[1048622] = 16
A[1048623] = 0
A[1048624] = 40
A[1048625] = 0
A[1048626] = 16
A[1048627] = 0
A[1048628] = 40
A[1048629] = 0
A[1048630] = 16
A[1048631] = 0
A[1048632] = 48
A[1048633] = 0
A[1048634] = 16
A[1048635] = 0
A[1048636] = 48
A[1048637] = 0
A[1048638] = 16
A[1048639] = 0
A[1048640] = 56
A[1048641] = 0
A[1048642] = 16
A[1048643] = 0
A[1048644] = 56
A[1048645] = 0
A[1048646] = 16
A[1048647] = 0
A[1048648] = 64
A[1048649] = 0
A[1048650] = 16
A[1048651] = 0
A[1048652] = 64
A[1048653] = 0
A[1048654] = 16
A[1048655] = 0
A[1048656] = 72
A[1048657] = 0
A[1048658] = 16
A[1048659] = 0
A[1048660] = 72
A[1048661] = 0
A[1048662] = 16
A[1048663] = 0
A[1048664] = 80
A[1048665] = 0
A[1048666] = 16
A[1048667] = 0
A[1048668] = 80
A[1048669] = 0
A[1048670] = 16
A[1048671] = 0
A[1048672] = 88
A[1048673] = 0
A[1048674] = 16
A[1048675] = 0
A[1048676] = 88
A[1048677] = 0
A[1048678] = 16
A[1048679] = 0
A[1048680] = 96
A[1048681] = 0
A[1048682] = 16
A[1048683] = 0
A[1048684] = 96
A[1048685] = 0
A[1048686] = 16
A[1048687] = 0
A[1048688] = 104
A[1048689] = 0
A[1048690] = 16
A[1048691] = 0
A[1048692] = 104
A[1048693] = 0
A[1048694] = 16
A[1048695] = 0
A[1048696] = 112
A[1048697] = 0
A[1048698] = 16
A[1048699] = 0
A[1048700] = 112
A[1048701] = 0
A[1048702] = 16
A[1048703] = 0
A[1048704] = 120
A[1048705] = 0
A[1048706] = 16
A[1048707] = 0
A[1048708] = 120
A[1048709] = 0
A[1048710] = 16
A[1048711] = 0
A[1048712] = 128
A[1048713] = 0
A[1048714] = 16
A[1048715] = 0
A[1048716] = 128
A[1048717] = 0
A[1048718] = 16
A[1048719] = 0
A[1048720] = 136
A[1048721] = 0
A[1048722] = 16
A[1048723] = 0
A[1048724] = 136
A[1048725] = 0
A[1048726] = 16
A[1048727] = 0
A[1048728] = 144
A[1048729] = 0
A[1048730] = 16
A[1048731] = 0
A[1048732] = 144
A[1048733] = 0
A[1048734] = 16
A[1048735] = 0
A[1048736] = 152
A[1048737] = 0
A[1048738] = 16
A[1048739] = 0
A[1048740] = 152
A[1048741] = 0
A[1048742] = 16
A[1048743] = 0
A[1048744] = 160
A[1048745] = 0
A[1048746] = 16
A[1048747] = 0
A[1048748] = 160
A[1048749] = 0
A[1048750] = 16
A[1048751] = 0
A[1048752] = 168
A[1048753] = 0
A[1048754] = 16
A[1048755] = 0
A[1048756] = 168
A[1048757] = 0
A[1048758] = 16
A[1048759] = 0
A[1048760] = 176
A[1048761] = 0
A[1048762] = 16
A[1048763] = 0
A[1048764] = 176
A[1048765] = 0
A[1048766] = 16
A[1048767] = 0
A[1048768] = 184
A[1048769] = 0
A[1048770] = 16
A[1048771] = 0
A[1048772] = 184
A[1048773] = 0
A[1048774] = 16
A[1048775] = 0
A[1048776] = 192
A[1048777] = 0
A[1048778] = 16
A[1048779] = 0
A[1048780] = 192
A[1048781] = 0
A[1048782] = 16
A[1048783] = 0
A[1048784] = 200
A[1048785] = 0
A[1048786] = 16
A[1048787] = 0
A[1048788] = 200
A[1048789] = 0
A[1048790] = 16
A[1048791] = 0
A[1048792] = 208
A[1048793] = 0
A[1048794] = 16
A[1048795] = 0
A[1048796] = 208
A[1048797] = 0
A[1048798] = 16
A[1048799] = 0
A[1048800] = 216
A[1048801] = 0
A[1048802] = 16
A[1048803] = 0
A[1048804] = 216
A[1048805] = 0
A[1048806] = 16
A[1048807] = 0
A[1048808] = 224
A[1048809] = 0
A[1048810] = 16
A[1048811] = 0
A[1048812] = 224
A[1048813] = 0
A[1048814] = 16
A[1048815] = 0
A[1048816] = 232
A[1048817] = 0
A[1048818] = 16
A[1048819] = 0
A[1048820] = 232
A[1048821] = 0
A[1048822] = 16
A[1048823] = 0
A[1048824] = 240
A[1048825] = 0
A[1048826] = 16
A[1048827] = 0
A[1048828] = 240
A[1048829] = 0
A[1048830] = 16
A[1048831] = 0
A[1048832] = 248
A[1048833] = 0
A[1048834] = 16
A[1048835] = 0
A[1048836] = 248
A[1048837] = 0
A[1048838] = 16
A[1048839] = 0
A[1048840] = 0
A[1048841] = 1
A[1048842] = 16
A[1048843] = 0
A[1048844] = 0
A[1048845] = 1
A[1048846] = 16
A[1048847] = 0
A[1048848] = 8
A[1048849] = 1
A[1048850] = 16
A[1048851] = 0
A[1048852] = 8
A[1048853] = 1
A[1048854] = 16
A[1048855] = 0
A[1048856] = 16
A[1048857] = 1
A[1048858] = 16
A[1048859] = 0
A[1048860] = 16
A[1048861] = 1
A[1048862] = 16
A[1048863] = 0
A[1048864] = 24
A[1048865] = 1
A[1048866] = 16
A[1048867] = 0
A[1048868] = 24
A[1048869] = 1
A[1048870] = 16
A[1048871] = 0
A[1048872] = 32
A[1048873] = 1
A[1048874] = 16
A[1048875] = 0
A[1048876] = 32
A[1048877] = 1
A[1048878] = 16
A[1048879] = 0
A[1048880] = 40
A[1048881] = 1
A[1048882] = 16
A[1048883] = 0
A[1048884] = 40
A[1048885] = 1
A[1048886] = 16
A[1048887] = 0
A[1048888] = 48
A[1048889] = 1
A[1048890] = 16
A[1048891] = 0
A[1048892] = 48
A[1048893] = 1
A[1048894] = 16
A[1048895] = 0
A[1048896] = 56
A[1048897] = 1
A[1048898] = 16
A[1048899] = 0
A[1048900] = 56
A[1048901] = 1
A[1048902] = 16
A[1048903] = 0
A[1048904] = 64
A[1048905] = 1
A[1048906] = 16
A[1048907] = 0
A[1048908] = 64
A[1048909] = 1
A[1048910] = 16
A[1048911] = 0
A[1048912] = 72
A[1048913] = 1
A[1048914] = 16
A[1048915] = 0
A[1048916] = 72
A[1048917] = 1
A[1048918] = 16
A[1048919] = 0
A[1048920] = 80
A[1048921] = 1
A[1048922] = 16
A[1048923] = 0
A[1048924] = 80
A[1048925] = 1
A[1048926] = 16
A[1048927] = 0
A[1048928] = 88
A[1048929] = 1
A[1048930] = 16
A[1048931] = 0
A[1048932] = 88
A[1048933] = 1
A[1048934] = 16
A[1048935] = 0
A[1048936] = 96
A[1048937] = 1
A[1048938] = 16
A[1048939] = 0
A[1048940] = 96
A[1048941] = 1
A[1048942] = 16
A[1048943] = 0
A[1048944] = 104
A[1048945] = 1
A[1048946] = 16
A[1048947] = 0
A[1048948] = 104
A[1048949] = 1
A[1048950] = 16
A[1048951] = 0
A[1048952] = 112
A[1048953] = 1
A[1048954] = 16
A[1048955] = 0
A[1048956] = 112
A[1048957] = 1
A[1048958] = 16
A[1048959] = 0
A[1048960] = 120
A[1048961] = 1
A[1048962] = 16
A[1048963] = 0
A[1048964] = 120
A[1048965] = 1
A[1048966] = 16
A[1048967] = 0
A[1048968] = 128
A[1048969] = 1
A[1048970] = 16
A[1048971] = 0
A[1048972] = 128
A[1048973] = 1
A[1048974] = 16
A[1048975] = 0
A[1048976] = 136
A[1048977] = 1
A[1048978] = 16
A[1048979] = 0
A[1048980] = 136
A[1048981] = 1
A[1048982] = 16
A[1048983] = 0
A[1048984] = 144
A[1048985] = 1
A[1048986] = 16
A[1048987] = 0
A[1048988] = 144
A[1048989] = 1
A[1048990] = 16
A[1048991] = 0
A[1048992] = 152
A[1048993] = 1
A[1048994] = 16
A[1048995] = 0
A[1048996] = 152
A[1048997] = 1
A[1048998] = 16
A[1048999] = 0
A[1049000] = 160
A[1049001] = 1
A[1049002] = 16
A[1049003] = 0
A[1049004] = 160
A[1049005] = 1
A[1049006] = 16
A[1049007] = 0
A[1049008] = 168
A[1049009] = 1
A[1049010] = 16
A[1049011] = 0
A[1049012] = 168
A[1049013] = 1
A[1049014] = 16
A[1049015] = 0
A[1049016] = 176
A[1049017] = 1
A[1049018] = 16
A[1049019] = 0
A[1049020] = 176
A[1049021] = 1
A[1049022] = 16
A[1049023] = 0
A[1049024] = 184
A[1049025] = 1
A[1049026] = 16
A[1049027] = 0
A[1049028] = 184
A[1049029] = 1
A[1049030] = 16
A[1049031] = 0
A[1049032] = 192
A[1049033] = 1
A[1049034] = 16
A[1049035] = 0
A[1049036] = 192
A[1049037] = 1
A[1049038] = 16
A[1049039] = 0
A[1049040] = 200
A[1049041] = 1
A[1049042] = 16
A[1049043] = 0
A[1049044] = 200
A[1049045] = 1
A[1049046] = 16
A[1049047] = 0
A[1049048] = 208
A[1049049] = 1
A[1049050] = 16
A[1049051] = 0
A[1049052] = 208
A[1049053] = 1
A[1049054] = 16
A[1049055] = 0
A[1049056] = 216
A[1049057] = 1
A[1049058] = 16
A[1049059] = 0
A[1049060] = 216
A[1049061] = 1
A[1049062] = 16
A[1049063] = 0
A[1049064] = 224
A[1049065] = 1
A[1049066] = 16
A[1049067] = 0
A[1049068] = 224
A[1049069] = 1
A[1049070] = 16
A[1049071] = 0
A[1049072] = 232
A[1049073] = 1
A[1049074] = 16
A[1049075] = 0
A[1049076] = 232
A[1049077] = 1
A[1049078] = 16
A[1049079] = 0
A[1049080] = 240
A[1049081] = 1
A[1049082] = 16
A[1049083] = 0
A[1049084] = 240
A[1049085] = 1
A[1049086] = 16
A[1049087] = 0
A[1049088] = 248
A[1049089] = 1
A[1049090] = 16
A[1049091] = 0
A[1049092] = 248
A[1049093] = 1
A[1049094] = 16
A[1049095] = 0
A[1049096] = 0
A[1049097] = 2
A[1049098] = 16
A[1049099] = 0
A[1049100] = 0
A[1049101] = 2
A[1049102] = 16
A[1049103] = 0
A[1049104] = 8
A[1049105] = 2
A[1049106] = 16
A[1049107] = 0
A[1049108] = 8
A[1049109] = 2
A[1049110] = 16
A[1049111] = 0
A[1049112] = 16
A[1049113] = 2
A[1049114] = 16
A[1049115] = 0
A[1049116] = 16
A[1049117] = 2
A[1049118] = 16
A[1049119] = 0
A[1049120] = 24
A[1049121] = 2
A[1049122] = 16
A[1049123] = 0
A[1049124] = 24
A[1049125] = 2
A[1049126] = 16
A[1049127] = 0
A[1049128] = 32
A[1049129] = 2
A[1049130] = 16
A[1049131] = 0
A[1049132] = 32
A[1049133] = 2
A[1049134] = 16
A[1049135] = 0
A[1049136] = 40
A[1049137] = 2
A[1049138] = 16
A[1049139] = 0
A[1049140] = 40
A[1049141] = 2
A[1049142] = 16
A[1049143] = 0
A[1049144] = 48
A[1049145] = 2
A[1049146] = 16
A[1049147] = 0
A[1049148] = 48
A[1049149] = 2
A[1049150] = 16
A[1049151] = 0
A[1049152] = 56
A[1049153] = 2
A[1049154] = 16
A[1049155] = 0
A[1049156] = 56
A[1049157] = 2
A[1049158] = 16
A[1049159] = 0
A[1049160] = 64
A[1049161] = 2
A[1049162] = 16
A[1049163] = 0
A[1049164] = 64
A[1049165] = 2
A[1049166] = 16
A[1049167] = 0
A[1049168] = 72
A[1049169] = 2
A[1049170] = 16
A[1049171] = 0
A[1049172] = 72
A[1049173] = 2
A[1049174] = 16
A[1049175] = 0
A[1049176] = 80
A[1049177] = 2
A[1049178] = 16
A[1049179] = 0
A[1049180] = 80
A[1049181] = 2
A[1049182] = 16
A[1049183] = 0
A[1049184] = 88
A[1049185] = 2
A[1049186] = 16
A[1049187] = 0
A[1049188] = 88
A[1049189] = 2
A[1049190] = 16
A[1049191] = 0
A[1049192] = 96
A[1049193] = 2
A[1049194] = 16
A[1049195] = 0
A[1049196] = 96
A[1049197] = 2
A[1049198] = 16
A[1049199] = 0
A[1049200] = 104
A[1049201] = 2
A[1049202] = 16
A[1049203] = 0
A[1049204] = 104
A[1049205] = 2
A[1049206] = 16
A[1049207] = 0
A[1049208] = 112
A[1049209] = 2
A[1049210] = 16
A[1049211] = 0
A[1049212] = 112
A[1049213] = 2
A[1049214] = 16
A[1049215] = 0
A[1049216] = 120
A[1049217] = 2
A[1049218] = 16
A[1049219] = 0
A[1049220] = 120
A[1049221] = 2
A[1049222] = 16
A[1049223] = 0
A[1049224] = 128
A[1049225] = 2
A[1049226] = 16
A[1049227] = 0
A[1049228] = 128
A[1049229] = 2
A[1049230] = 16
A[1049231] = 0
A[1049232] = 136
A[1049233] = 2
A[1049234] = 16
A[1049235] = 0
A[1049236] = 136
A[1049237] = 2
A[1049238] = 16
A[1049239] = 0
A[1049240] = 144
A[1049241] = 2
A[1049242] = 16
A[1049243] = 0
A[1049244] = 144
A[1049245] = 2
A[1049246] = 16
A[1049247] = 0
A[1049248] = 152
A[1049249] = 2
A[1049250] = 16
A[1049251] = 0
A[1049252] = 152
A[1049253] = 2
A[1049254] = 16
A[1049255] = 0
A[1049256] = 160
A[1049257] = 2
A[1049258] = 16
A[1049259] = 0
A[1049260] = 160
A[1049261] = 2
A[1049262] = 16
A[1049263] = 0
A[1049264] = 168
A[1049265] = 2
A[1049266] = 16
A[1049267] = 0
A[1049268] = 168
A[1049269] = 2
A[1049270] = 16
A[1049271] = 0
A[1049272] = 176
A[1049273] = 2
A[1049274] = 16
A[1049275] = 0
A[1049276] = 176
A[1049277] = 2
A[1049278] = 16
A[1049279] = 0
A[1049280] = 184
A[1049281] = 2
A[1049282] = 16
A[1049283] = 0
A[1049284] = 184
A[1049285] = 2
A[1049286] = 16
A[1049287] = 0
A[1049288] = 192
A[1049289] = 2
A[1049290] = 16
A[1049291] = 0
A[1049292] = 192
A[1049293] = 2
A[1049294] = 16
A[1049295] = 0
A[1049296] = 200
A[1049297] = 2
A[1049298] = 16
A[1049299] = 0
A[1049300] = 200
A[1049301] = 2
A[1049302] = 16
A[1049303] = 0
A[1049304] = 208
A[1049305] = 2
A[1049306] = 16
A[1049307] = 0
A[1049308] = 208
A[1049309] = 2
A[1049310] = 16
A[1049311] = 0
A[1049312] = 216
A[1049313] = 2
A[1049314] = 16
A[1049315] = 0
A[1049316] = 216
A[1049317] = 2
A[1049318] = 16
A[1049319] = 0
A[1049320] = 224
A[1049321] = 2
A[1049322] = 16
A[1049323] = 0
A[1049324] = 224
A[1049325] = 2
A[1049326] = 16
A[1049327] = 0
A[1049328] = 232
A[1049329] = 2
A[1049330] = 16
A[1049331] = 0
A[1049332] = 232
A[1049333] = 2
A[1049334] = 16
A[1049335] = 0
A[1049336] = 240
A[1049337] = 2
A[1049338] = 16
A[1049339] = 0
A[1049340] = 240
A[1049341] = 2
A[1049342] = 16
A[1049343] = 0
A[1049344] = 248
A[1049345] = 2
A[1049346] = 16
A[1049347] = 0
A[1049348] = 248
A[1049349] = 2
A[1049350] = 16
A[1049351] = 0
A[1049352] = 0
A[1049353] = 3
A[1049354] = 16
A[1049355] = 0
A[1049356] = 0
A[1049357] = 3
A[1049358] = 16
A[1049359] = 0
A[1049360] = 8
A[1049361] = 3
A[1049362] = 16
A[1049363] = 0
A[1049364] = 8
A[1049365] = 3
A[1049366] = 16
A[1049367] = 0
A[1049368] = 16
A[1049369] = 3
A[1049370] = 16
A[1049371] = 0
A[1049372] = 16
A[1049373] = 3
A[1049374] = 16
A[1049375] = 0
A[1049376] = 24
A[1049377] = 3
A[1049378] = 16
A[1049379] = 0
A[1049380] = 24
A[1049381] = 3
A[1049382] = 16
A[1049383] = 0
A[1049384] = 32
A[1049385] = 3
A[1049386] = 16
A[1049387] = 0
A[1049388] = 32
A[1049389] = 3
A[1049390] = 16
A[1049391] = 0
A[1049392] = 40
A[1049393] = 3
A[1049394] = 16
A[1049395] = 0
A[1049396] = 40
A[1049397] = 3
A[1049398] = 16
A[1049399] = 0
A[1049400] = 48
A[1049401] = 3
A[1049402] = 16
A[1049403] = 0
A[1049404] = 48
A[1049405] = 3
A[1049406] = 16
A[1049407] = 0
A[1049408] = 56
A[1049409] = 3
A[1049410] = 16
A[1049411] = 0
A[1049412] = 56
A[1049413] = 3
A[1049414] = 16
A[1049415] = 0
A[1049416] = 64
A[1049417] = 3
A[1049418] = 16
A[1049419] = 0
A[1049420] = 64
A[1049421] = 3
A[1049422] = 16
A[1049423] = 0
A[1049424] = 72
A[1049425] = 3
A[1049426] = 16
A[1049427] = 0
A[1049428] = 72
A[1049429] = 3
A[1049430] = 16
A[1049431] = 0
A[1049432] = 80
A[1049433] = 3
A[1049434] = 16
A[1049435] = 0
A[1049436] = 80
A[1049437] = 3
A[1049438] = 16
A[1049439] = 0
A[1049440] = 88
A[1049441] = 3
A[1049442] = 16
A[1049443] = 0
A[1049444] = 88
A[1049445] = 3
A[1049446] = 16
A[1049447] = 0
A[1049448] = 96
A[1049449] = 3
A[1049450] = 16
A[1049451] = 0
A[1049452] = 96
A[1049453] = 3
A[1049454] = 16
A[1049455] = 0
A[1049456] = 104
A[1049457] = 3
A[1049458] = 16
A[1049459] = 0
A[1049460] = 104
A[1049461] = 3
A[1049462] = 16
A[1049463] = 0
A[1049464] = 112
A[1049465] = 3
A[1049466] = 16
A[1049467] = 0
A[1049468] = 112
A[1049469] = 3
A[1049470] = 16
A[1049471] = 0
A[1049472] = 120
A[1049473] = 3
A[1049474] = 16
A[1049475] = 0
A[1049476] = 120
A[1049477] = 3
A[1049478] = 16
A[1049479] = 0
A[1049480] = 128
A[1049481] = 3
A[1049482] = 16
A[1049483] = 0
A[1049484] = 128
A[1049485] = 3
A[1049486] = 16
A[1049487] = 0
A[1049488] = 136
A[1049489] = 3
A[1049490] = 16
A[1049491] = 0
A[1049492] = 136
A[1049493] = 3
A[1049494] = 16
A[1049495] = 0
A[1049496] = 144
A[1049497] = 3
A[1049498] = 16
A[1049499] = 0
A[1049500] = 144
A[1049501] = 3
A[1049502] = 16
A[1049503] = 0
A[1049504] = 152
A[1049505] = 3
A[1049506] = 16
A[1049507] = 0
A[1049508] = 152
A[1049509] = 3
A[1049510] = 16
A[1049511] = 0
A[1049512] = 160
A[1049513] = 3
A[1049514] = 16
A[1049515] = 0
A[1049516] = 160
A[1049517] = 3
A[1049518] = 16
A[1049519] = 0
A[1049520] = 168
A[1049521] = 3
A[1049522] = 16
A[1049523] = 0
A[1049524] = 168
A[1049525] = 3
A[1049526] = 16
A[1049527] = 0
A[1049528] = 176
A[1049529] = 3
A[1049530] = 16
A[1049531] = 0
A[1049532] = 176
A[1049533] = 3
A[1049534] = 16
A[1049535] = 0
A[1049536] = 184
A[1049537] = 3
A[1049538] = 16
A[1049539] = 0
A[1049540] = 184
A[1049541] = 3
A[1049542] = 16
A[1049543] = 0
A[1049544] = 192
A[1049545] = 3
A[1049546] = 16
A[1049547] = 0
A[1049548] = 192
A[1049549] = 3
A[1049550] = 16
A[1049551] = 0
A[1049552] = 200
A[1049553] = 3
A[1049554] = 16
A[1049555] = 0
A[1049556] = 200
A[1049557] = 3
A[1049558] = 16
A[1049559] = 0
A[1049560] = 208
A[1049561] = 3
A[1049562] = 16
A[1049563] = 0
A[1049564] = 208
A[1049565] = 3
A[1049566] = 16
A[1049567] = 0
A[1049568] = 216
A[1049569] = 3
A[1049570] = 16
A[1049571] = 0
A[1049572] = 216
A[1049573] = 3
A[1049574] = 16
A[1049575] = 0
A[1049576] = 224
A[1049577] = 3
A[1049578] = 16
A[1049579] = 0
A[1049580] = 224
A[1049581] = 3
A[1049582] = 16
A[1049583] = 0
A[1049584] = 232
A[1049585] = 3
A[1049586] = 16
A[1049587] = 0
A[1049588] = 232
A[1049589] = 3
A[1049590] = 16
A[1049591] = 0
A[1049592] = 240
A[1049593] = 3
A[1049594] = 16
A[1049595] = 0
A[1049596] = 240
A[1049597] = 3
A[1049598] = 16
A[1049599] = 0
A[1049600] = 248
A[1049601] = 3
A[1049602] = 16
A[1049603] = 0
A[1049604] = 248
A[1049605] = 3
A[1049606] = 16
A[1049607] = 0
A[1049608] = 0
A[1049609] = 4
A[1049610] = 16
A[1049611] = 0
A[1049612] = 0
A[1049613] = 4
A[1049614] = 16
A[1049615] = 0
A[1049616] = 105
A[1049617] = 32
A[1049618] = 97
A[1049619] = 109
A[1049620] = 32
A[1049621] = 99
A[1049622] = 111
A[1049623] = 110
A[1049624] = 115
A[1049625] = 116
A[1049626] = 49
A[1049627] = 0
A[1049628] = 104
A[1049629] = 101
A[1049630] = 108
A[1049631] = 108
A[1049632] = 111
A[1049633] = 0
A[1049634] = 105
A[1049635] = 32
A[1049636] = 97
A[1049637] = 109
A[1049638] = 32
A[1049639] = 99
A[1049640] = 111
A[1049641] = 110
A[1049642] = 115
A[1049643] = 116
A[1049644] = 50
A[1049645] = 44
local L, M, N
function L()
  error("Unreachable code reached..", 2)
end
function M(O)
  local P = 0
  local Q = 0
  local R = 0
  local S = 0
  local T = 0
  local U = 0
  local V = 0
  local W = 0
  local X = 0
  local Y = 0
  P = (O + 11)
  P = (checkCondition(((P < 23) and 1 or 0)) and 16) or ((bit.band((O + 11), -8)))
 if checkCondition((((checkCondition(((P < 23) and 1 or 0)) and 16) or ((bit.band((O + 11), -8))) < 0) and 1 or 0)) then 
	::ZStart::
  if true then return 0 end
	::ZFinish::
  end
 if checkCondition(((P < O) and 1 or 0)) then 
	::BAStart::
  if true then return 0 end
	::BAFinish::
  end
  local BB
  if checkCondition(((P < 504) and 1 or 0)) then ::BCStart::
  Q = (1048584 + (bit.lshift((bit.rshift(P, 2)), 2)))
  R = (readMem(A, ASize, (1048584 + (bit.lshift((bit.rshift(P, 2)), 2))), 32))
 if checkCondition((((readMem(A, ASize, (1048584 + (bit.lshift((bit.rshift(P, 2)), 2))), 32)) == Q) and 1 or 0)) then 
	::BDStart::
  R = (readMem(A, ASize, Q, 32))
  Q = (8 + Q)
	::BDFinish::
  end
 if checkCondition(((R ~= Q) and 1 or 0)) then 
	::BEStart::
  Q = (readMem(A, ASize, R, 32))
  P = (readMem(A, ASize, R, 32))
  U = (readMem(A, ASize, R, 32))
  storeMem(A, ASize, (readMem(A, ASize, R, 32)), P, 32)
  storeMem(A, ASize, (readMem(A, ASize, R, 32)), U, 32)
  storeMem(A, ASize, ((bit.band((readMem(A, ASize, R, 32)), -4)) + R), (bit.bor((readMem(A, ASize, ((bit.band(Q, -4)) + R), 32)), 1)), 32)
  if true then return (8 + R) end
	::BEFinish::
  end
  BB = ((bit.rshift(P, 3)) + 2)
  else
  Q = (bit.rshift(P, 9))
  local BF
  if checkCondition((bit.rshift(P, 9))) then ::BGStart::
  local BH
  if checkCondition(((P < 2560) and 1 or 0)) then ::BIStart::
  BH = ((bit.rshift(P, 6)) + 56)
  else
  local BJ
  if checkCondition(((P < 10752) and 1 or 0)) then ::BKStart::
  BJ = (Q + 91)
  else
  local BL
  if checkCondition(((P < 43520) and 1 or 0)) then ::BMStart::
  BL = ((bit.rshift(P, 12)) + 110)
  else
  local BN
  if checkCondition(((P < 174592) and 1 or 0)) then ::BOStart::
  BN = ((bit.rshift(P, 15)) + 119)
  else
  local BP
  if checkCondition(((P < 698880) and 1 or 0)) then ::BQStart::
  BP = ((bit.rshift(P, 18)) + 124)
  else
	::BQFinish::
   BP = 126
 end
	::BOFinish::
   BN = BP
 end
	::BMFinish::
   BL = BN
 end
	::BKFinish::
   BJ = BL
 end
	::BIFinish::
   BH = BJ
 end
  BF = BH
  else
	::BGFinish::
   BF = (bit.rshift(P, 3))
 end
  Q = BF
  R = (1048584 + (bit.lshift(Q, 3)))
  U = (readMem(A, ASize, (1048584 + (bit.lshift(Q, 3))), 32))
 do 
	::BRStart::
 if checkCondition(((U ~= R) and 1 or 0)) then 
	::BSStart::
  W = (bit.band((readMem(A, ASize, U, 32)), -4))
  V = ((bit.band((readMem(A, ASize, U, 32)), -4)) - P)
 if checkCondition(((((bit.band((readMem(A, ASize, U, 32)), -4)) - P) <= 15) and 1 or 0)) then 
	::BTStart::
  X = (readMem(A, ASize, U, 32))
 if checkCondition(((V > -1) and 1 or 0)) then 
	::BUStart::
  P = (readMem(A, ASize, U, 32))
  storeMem(A, ASize, (readMem(A, ASize, U, 32)), X, 32)
  storeMem(A, ASize, X, P, 32)
  storeMem(A, ASize, (W + U), (bit.bor((readMem(A, ASize, (W + U), 32)), 1)), 32)
  if true then return (8 + U) end
	::BUFinish::
  end
  U = (readMem(A, ASize, U, 32))
 goto BRStart
	::BTFinish::
  end
  Q = (Q + -1)
	::BSFinish::
  end
	::BRFinish::
  end
	::BCFinish::
   BB = (Q + 1)
 end
  S = BB
  T = (readMem(A, ASize, 1048600, 32))
 if checkCondition((((readMem(A, ASize, 1048600, 32)) ~= 1048592) and 1 or 0)) then 
	::BVStart::
  X = (readMem(A, ASize, T, 32))
  U = (bit.band((readMem(A, ASize, T, 32)), -4))
  Y = ((bit.band((readMem(A, ASize, T, 32)), -4)) - P)
 if checkCondition(((((bit.band((readMem(A, ASize, T, 32)), -4)) - P) > 15) and 1 or 0)) then 
	::BWStart::
  storeMem(A, ASize, T, (bit.bor(P, 1)), 32)
  S = (P + T)
  storeMem(A, ASize, 1048604, (P + T), 32)
  storeMem(A, ASize, 1048600, S, 32)
  storeMem(A, ASize, S, H, 64)
  storeMem(A, ASize, S, (bit.bor(Y, 1)), 32)
  storeMem(A, ASize, (U + T), Y, 32)
  if true then return (8 + T) end
	::BWFinish::
  end
  storeMem(A, ASize, 1048604, 1048592, 32)
  storeMem(A, ASize, 1048600, 1048592, 32)
 if checkCondition(((Y > -1) and 1 or 0)) then 
	::BXStart::
  storeMem(A, ASize, (U + T), (bit.bor((readMem(A, ASize, (U + T), 32)), 1)), 32)
  if true then return (8 + T) end
	::BXFinish::
  end
 if checkCondition(((U < 512) and 1 or 0)) then 
	::BYStart::
  storeMem(A, ASize, 1048588, (bit.bor((readMem(A, ASize, 1048588, 32)), (bit.lshift(1, (bit.rshift(X, 5)))))), 32)
  U = (1048584 + (bit.lshift((bit.rshift(X, 3)), 3)))
  Y = (readMem(A, ASize, (1048584 + (bit.lshift((bit.rshift(X, 3)), 3))), 32))
  storeMem(A, ASize, T, U, 32)
  storeMem(A, ASize, T, Y, 32)
  storeMem(A, ASize, U, T, 32)
  storeMem(A, ASize, (readMem(A, ASize, (1048584 + (bit.lshift((bit.rshift(X, 3)), 3))), 32)), T, 32)
  else
  Y = (bit.rshift(X, 9))
  local BZ
  if checkCondition((bit.rshift(X, 9))) then ::CAStart::
  local CB
  if checkCondition(((X < 2560) and 1 or 0)) then ::CCStart::
  CB = ((bit.rshift(X, 6)) + 56)
  else
  local CD
  if checkCondition(((X < 10752) and 1 or 0)) then ::CEStart::
  CD = (Y + 91)
  else
  local CF
  if checkCondition(((X < 43520) and 1 or 0)) then ::CGStart::
  CF = ((bit.rshift(X, 12)) + 110)
  else
  local CH
  if checkCondition(((X < 174592) and 1 or 0)) then ::CIStart::
  CH = ((bit.rshift(X, 15)) + 119)
  else
  local CJ
  if checkCondition(((X < 698880) and 1 or 0)) then ::CKStart::
  CJ = ((bit.rshift(X, 18)) + 124)
  else
	::CKFinish::
   CJ = 126
 end
	::CIFinish::
   CH = CJ
 end
	::CGFinish::
   CF = CH
 end
	::CEFinish::
   CD = CF
 end
	::CCFinish::
   CB = CD
 end
  BZ = CB
  else
	::CAFinish::
   BZ = (bit.rshift(X, 3))
 end
  W = BZ
  Y = (1048584 + (bit.lshift(W, 3)))
  X = (readMem(A, ASize, (1048584 + (bit.lshift(W, 3))), 32))
 if checkCondition((((readMem(A, ASize, (1048584 + (bit.lshift(W, 3))), 32)) == Y) and 1 or 0)) then 
	::CLStart::
  storeMem(A, ASize, 1048588, (bit.bor((readMem(A, ASize, 1048588, 32)), (bit.lshift(1, (bit.rshift(W, 2)))))), 32)
  X = Y
  else
 do 
	::CMStart::
 if checkCondition(((U < (bit.band((readMem(A, ASize, X, 32)), -4))) and 1 or 0)) then 
	::CNStart::
  X = (readMem(A, ASize, X, 32))
  if checkCondition((((readMem(A, ASize, X, 32)) ~= Y) and 1 or 0)) then
      goto CMStart
  end
  X = Y
	::CNFinish::
  end
	::CMFinish::
  end
  Y = (readMem(A, ASize, X, 32))
	::CLFinish::
  end
  storeMem(A, ASize, T, Y, 32)
  storeMem(A, ASize, T, X, 32)
  storeMem(A, ASize, Y, T, 32)
  storeMem(A, ASize, X, T, 32)
	::BYFinish::
  end
	::BVFinish::
  end
  T = (bit.lshift(1, (math.floor(S / 4))))
  U = (readMem(A, ASize, 1048588, 32))
 if checkCondition((((bit.lshift(1, (math.floor(S / 4)))) <= (readMem(A, ASize, 1048588, 32))) and 1 or 0)) then 
	::COStart::
 if checkCondition((((bit.band(U, T)) == 0) and 1 or 0)) then 
	::CPStart::
  S = (bit.band((S + 4), -4))
 do 
	::CQStart::
  T = (bit.lshift(T, 1))
  if checkCondition((bit.band((bit.lshift(T, 1)), U))) then
      goto CPFinish
  end
  S = (S + 4)
 goto CQStart
	::CQFinish::
  end
	::CPFinish::
  end
 do 
	::CRStart::
  Y = (1048584 + (bit.lshift(S, 3)))
  W = (1048584 + (bit.lshift(S, 3)))
  X = S
 do 
	::CSStart::
  Q = (readMem(A, ASize, W, 32))
 if checkCondition((((readMem(A, ASize, W, 32)) ~= W) and 1 or 0)) then 
	::CTStart::
 do 
	::CUStart::
  R = (bit.band((readMem(A, ASize, Q, 32)), -4))
  V = ((bit.band((readMem(A, ASize, Q, 32)), -4)) - P)
 if checkCondition(((((bit.band((readMem(A, ASize, Q, 32)), -4)) - P) > 15) and 1 or 0)) then 
	::CVStart::
  storeMem(A, ASize, Q, (bit.bor(P, 1)), 32)
  U = (P + Q)
  P = (readMem(A, ASize, Q, 32))
  W = (readMem(A, ASize, Q, 32))
  storeMem(A, ASize, (readMem(A, ASize, Q, 32)), P, 32)
  storeMem(A, ASize, (readMem(A, ASize, Q, 32)), W, 32)
  storeMem(A, ASize, 1048604, U, 32)
  storeMem(A, ASize, 1048600, U, 32)
  storeMem(A, ASize, U, H, 64)
  storeMem(A, ASize, U, (bit.bor(V, 1)), 32)
  storeMem(A, ASize, (R + Q), V, 32)
  if true then return (8 + Q) end
	::CVFinish::
  end
 if checkCondition(((V > -1) and 1 or 0)) then 
	::CWStart::
  storeMem(A, ASize, (R + Q), (bit.bor((readMem(A, ASize, (R + Q), 32)), 1)), 32)
  R = (readMem(A, ASize, Q, 32))
  V = (readMem(A, ASize, Q, 32))
  storeMem(A, ASize, (readMem(A, ASize, Q, 32)), R, 32)
  storeMem(A, ASize, (readMem(A, ASize, Q, 32)), V, 32)
  if true then return (8 + Q) end
	::CWFinish::
  end
  Q = (readMem(A, ASize, Q, 32))
  if checkCondition((((readMem(A, ASize, Q, 32)) ~= W) and 1 or 0)) then
      goto CUStart
  end
	::CUFinish::
  end
	::CTFinish::
  end
  X = (X + 1)
 if checkCondition((bit.band((X + 1), 3))) then 
	::CXStart::
  W = (8 + W)
 goto CSStart
	::CXFinish::
  end
	::CSFinish::
  end
 do 
	::CYStart::
 if checkCondition((bit.band(S, 3))) then 
	::CZStart::
  Y = (-8 + Y)
 if checkCondition((((readMem(A, ASize, (-8 + Y), 32)) == Y) and 1 or 0)) then 
	::DAStart::
  S = (S + -1)
 goto CYStart
	::DAFinish::
  end
  else
  U = (bit.band(U, (bit.bxor(T, -1))))
  storeMem(A, ASize, 1048588, (bit.band(U, (bit.bxor(T, -1)))), 32)
	::CZFinish::
  end
	::CYFinish::
  end
  T = (bit.lshift(T, 1))
  S = (((bit.lshift(T, 1)) <= U) and 1 or 0)
  if checkCondition(((T == 0) and 1 or 0)) then
      goto COFinish
  end
  if checkCondition(((S == 0) and 1 or 0)) then
      goto COFinish
  end
 if checkCondition((bit.band(U, T))) then 
	::DBStart::
  S = X
  else
  S = X
 do 
	::DCStart::
  T = (bit.lshift(T, 1))
  S = (S + 4)
  if checkCondition((((bit.band((bit.lshift(T, 1)), U)) == 0) and 1 or 0)) then
      goto DCStart
  end
	::DCFinish::
  end
	::DBFinish::
  end
 goto CRStart
	::CRFinish::
  end
	::COFinish::
  end
  Q = (readMem(A, ASize, 1048592, 32))
  R = (bit.band((readMem(A, ASize, (readMem(A, ASize, 1048592, 32)), 32)), -4))
  U = ((bit.band((readMem(A, ASize, (readMem(A, ASize, 1048592, 32)), 32)), -4)) - P)
 do 
	::DDStart::
 if checkCondition(((R >= P) and 1 or 0)) then 
	::DEStart::
  if checkCondition(((U >= 16) and 1 or 0)) then
      goto DDFinish
  end
	::DEFinish::
  end
  V = (R + Q)
  local DF
  if checkCondition(((G == -1) and 1 or 0)) then ::DGStart::
  DF = (P + 16)
  else
	::DGFinish::
   DF = (bit.band((P + 4111), -4096))
 end
  W = DF
  T = C
 if checkCondition(((C == 0) and 1 or 0)) then 
	::DHStart::
  T = F
  C = F
	::DHFinish::
  end
 do 
	::DIStart::
 if checkCondition(W) then 
	::DJStart::
  local DK
  if checkCondition((((W + T) < D) and 1 or 0)) then ::DLStart::
  DK = T
  else
  local DM = imports.__growLinearMemory(W)
  U = DM
  if checkCondition(((DM == -1) and 1 or 0)) then
    DK = nil
  DK = nil
    goto DIFinish
  end
  D = (U + D)
	::DLFinish::
   DK = C
 end
  X = (DK + W)
  C = (DK + W)
  S = T
  else
  S = D
  X = T
	::DJFinish::
  end
  if checkCondition(((S == -1) and 1 or 0)) then
      goto DIFinish
  end
  U = ((S >= V) and 1 or 0)
  T = ((Q == 1048584) and 1 or 0)
 if checkCondition(((((Q == 1048584) and 1 or 0) == 0) and 1 or 0)) then 
	::DNStart::
  if checkCondition(((U == 0) and 1 or 0)) then
      goto DIFinish
  end
	::DNFinish::
  end
  U = (E + W)
  E = (E + W)
 do 
	::DOStart::
 if checkCondition(((S == V) and 1 or 0)) then 
	::DPStart::
  if checkCondition((bit.band(V, 4095))) then
      goto DPFinish
  end
  storeMem(A, ASize, (readMem(A, ASize, 1048592, 32)), (bit.bor((W + R), 1)), 32)
 goto DOFinish
	::DPFinish::
  end
 if checkCondition(((G == -1) and 1 or 0)) then 
	::DQStart::
  G = S
  else
  E = ((S - V) + U)
	::DQFinish::
  end
  U = (bit.band((8 + S), 7))
 if checkCondition((bit.band((8 + S), 7))) then 
	::DRStart::
  V = (8 - U)
  S = ((8 - U) + S)
  else
  V = 0
	::DRFinish::
  end
  U = ((4096 - (bit.band((W + S), 4095))) + V)
 if checkCondition(((X == 0) and 1 or 0)) then 
	::DSStart::
  X = F
  C = F
	::DSFinish::
  end
 do 
	::DTStart::
  local DU
  if checkCondition((((U + X) < D) and 1 or 0)) then ::DVStart::
  DU = X
  else
  local DW = imports.__growLinearMemory(U)
  V = DW
 if checkCondition(((DW == -1) and 1 or 0)) then 
	::DXStart::
  X = -1
 goto DTFinish
	::DXFinish::
  end
  D = (V + D)
	::DVFinish::
   DU = C
 end
  C = (DU + U)
	::DTFinish::
  end
  V = ((X == -1) and 1 or 0)
  W = (checkCondition(((X == -1) and 1 or 0)) and 0) or (U)
  U = ((checkCondition(((X == -1) and 1 or 0)) and 0) or (U) + E)
  E = ((checkCondition(((X == -1) and 1 or 0)) and 0) or (U) + E)
  storeMem(A, ASize, 1048592, S, 32)
  storeMem(A, ASize, S, (bit.bor(((W - S) + (checkCondition(V == 0) and X) or (S)), 1)), 32)
  if checkCondition(T) then
      goto DOFinish
  end
 if checkCondition(((R < 16) and 1 or 0)) then 
	::DYStart::
  storeMem(A, ASize, S, 1, 32)
 goto DIFinish
	::DYFinish::
  end
  R = (bit.band((R + -12), -8))
  storeMem(A, ASize, Q, (bit.bor((bit.band((readMem(A, ASize, Q, 32)), 1)), (bit.band((R + -12), -8)))), 32)
  storeMem(A, ASize, (R + Q), 5, 32)
  storeMem(A, ASize, (R + Q), 5, 32)
  if checkCondition(((R <= 15) and 1 or 0)) then
      goto DOFinish
  end
  if checkCondition(((F > (8 + Q)) and 1 or 0)) then
      goto DOFinish
  end
  V = (readMem(A, ASize, Q, 32))
  W = (bit.band((readMem(A, ASize, Q, 32)), -2))
  X = ((bit.band((readMem(A, ASize, Q, 32)), -2)) + Q)
  T = (bit.band((readMem(A, ASize, ((bit.band((readMem(A, ASize, Q, 32)), -2)) + Q), 32)), -4))
 if checkCondition(((S == X) and 1 or 0)) then 
	::DZStart::
  R = (T + W)
  local EA
  if checkCondition((bit.band(V, 1))) then ::EBStart::
  EA = Q
  else
  V = (readMem(A, ASize, Q, 32))
  Q = (Q - V)
  W = (readMem(A, ASize, (Q - V), 32))
  X = (readMem(A, ASize, Q, 32))
  storeMem(A, ASize, (readMem(A, ASize, Q, 32)), W, 32)
  storeMem(A, ASize, (readMem(A, ASize, (Q - V), 32)), X, 32)
  R = (V + R)
	::EBFinish::
   EA = Q
 end
  W = EA
  storeMem(A, ASize, EA, (bit.bor(R, 1)), 32)
  storeMem(A, ASize, 1048592, W, 32)
 if checkCondition(((R >= 131072) and 1 or 0)) then 
	::ECStart::
  W = (bit.band(R, -4))
  R = (bit.band(((bit.band(R, -4)) + -17), -4096))
  if checkCondition((((bit.band(((bit.band(R, -4)) + -17), -4096)) < 4096) and 1 or 0)) then
      goto ECFinish
  end
  V = C
 if checkCondition(((C == 0) and 1 or 0)) then 
	::EDStart::
  V = F
  C = F
	::EDFinish::
  end
  if checkCondition(((D ~= (W + Q)) and 1 or 0)) then
      goto ECFinish
  end
 if checkCondition(((V == 0) and 1 or 0)) then 
	::EEStart::
  V = F
  C = F
	::EEFinish::
  end
  U = (0 - R)
 do 
	::EFStart::
  local EG
  if checkCondition((((U + V) < D) and 1 or 0)) then ::EHStart::
  EG = V
  else
  local EI = imports.__growLinearMemory(U)
  Q = EI
 if checkCondition(((EI == -1) and 1 or 0)) then 
	::EJStart::
  U = C
 goto EFFinish
	::EJFinish::
  end
  D = (Q + D)
	::EHFinish::
   EG = C
 end
  U = (EG + U)
  C = (EG + U)
  if checkCondition(((V == -1) and 1 or 0)) then
      goto EFFinish
  end
  storeMem(A, ASize, (readMem(A, ASize, 1048592, 32)), (bit.bor((W - R), 1)), 32)
  U = (E - R)
  E = (E - R)
 goto DOFinish
	::EFFinish::
  end
 if checkCondition(((U == 0) and 1 or 0)) then 
	::EKStart::
  C = F
	::EKFinish::
  end
  U = D
  R = (readMem(A, ASize, 1048592, 32))
  Q = (D - (readMem(A, ASize, 1048592, 32)))
 if checkCondition((((D - (readMem(A, ASize, 1048592, 32))) > 15) and 1 or 0)) then 
	::ELStart::
  U = (U - G)
  E = (U - G)
  storeMem(A, ASize, R, (bit.bor(Q, 1)), 32)
  else
  U = E
	::ELFinish::
  end
	::ECFinish::
  end
  else
  storeMem(A, ASize, X, T, 32)
 if checkCondition((bit.band(V, 1))) then 
	::EMStart::
  V = Q
  S = 0
  else
  R = (readMem(A, ASize, Q, 32))
  W = ((readMem(A, ASize, Q, 32)) + W)
  Q = (Q - R)
  R = (readMem(A, ASize, (Q - R), 32))
 if checkCondition((((readMem(A, ASize, (Q - R), 32)) == 1048592) and 1 or 0)) then 
	::ENStart::
  V = Q
  S = 1
  else
  V = (readMem(A, ASize, Q, 32))
  storeMem(A, ASize, R, V, 32)
  storeMem(A, ASize, (readMem(A, ASize, Q, 32)), R, 32)
  V = Q
  S = 0
	::ENFinish::
  end
	::EMFinish::
  end
 if checkCondition((((bit.band((readMem(A, ASize, (T + X), 32)), 1)) == 0) and 1 or 0)) then 
	::EOStart::
  W = (W + T)
  R = (readMem(A, ASize, X, 32))
 if checkCondition((bit.bor((bit.bxor((readMem(A, ASize, X, 32)), 1048592)), S))) then 
	::EPStart::
  X = (readMem(A, ASize, X, 32))
  storeMem(A, ASize, R, X, 32)
  storeMem(A, ASize, (readMem(A, ASize, X, 32)), R, 32)
  else
  storeMem(A, ASize, 1048604, V, 32)
  storeMem(A, ASize, 1048600, V, 32)
  storeMem(A, ASize, V, H, 64)
  S = 1
	::EPFinish::
  end
	::EOFinish::
  end
  storeMem(A, ASize, V, (bit.bor(W, 1)), 32)
  storeMem(A, ASize, (W + Q), W, 32)
  if checkCondition(S) then
      goto DZFinish
  end
 if checkCondition(((W < 512) and 1 or 0)) then 
	::EQStart::
  storeMem(A, ASize, 1048588, (bit.bor((readMem(A, ASize, 1048588, 32)), (bit.lshift(1, (bit.rshift(W, 5)))))), 32)
  Q = (1048584 + (bit.lshift((bit.rshift(W, 3)), 3)))
  R = (readMem(A, ASize, (1048584 + (bit.lshift((bit.rshift(W, 3)), 3))), 32))
  storeMem(A, ASize, V, Q, 32)
  storeMem(A, ASize, V, R, 32)
  storeMem(A, ASize, Q, V, 32)
  storeMem(A, ASize, (readMem(A, ASize, (1048584 + (bit.lshift((bit.rshift(W, 3)), 3))), 32)), V, 32)
  else
  R = (bit.rshift(W, 9))
  local ER
  if checkCondition((bit.rshift(W, 9))) then ::ESStart::
  local ET
  if checkCondition(((W < 2560) and 1 or 0)) then ::EUStart::
  ET = ((bit.rshift(W, 6)) + 56)
  else
  local EV
  if checkCondition(((W < 10752) and 1 or 0)) then ::EWStart::
  EV = (R + 91)
  else
  local EX
  if checkCondition(((W < 43520) and 1 or 0)) then ::EYStart::
  EX = ((bit.rshift(W, 12)) + 110)
  else
  local EZ
  if checkCondition(((W < 174592) and 1 or 0)) then ::FAStart::
  EZ = ((bit.rshift(W, 15)) + 119)
  else
  local FB
  if checkCondition(((W < 698880) and 1 or 0)) then ::FCStart::
  FB = ((bit.rshift(W, 18)) + 124)
  else
	::FCFinish::
   FB = 126
 end
	::FAFinish::
   EZ = FB
 end
	::EYFinish::
   EX = EZ
 end
	::EWFinish::
   EV = EX
 end
	::EUFinish::
   ET = EV
 end
  ER = ET
  else
	::ESFinish::
   ER = (bit.rshift(W, 3))
 end
  R = ER
  S = (1048584 + (bit.lshift(R, 3)))
  T = (readMem(A, ASize, (1048584 + (bit.lshift(R, 3))), 32))
  local FD
  if checkCondition((((readMem(A, ASize, (1048584 + (bit.lshift(R, 3))), 32)) == S) and 1 or 0)) then ::FEStart::
  storeMem(A, ASize, 1048588, (bit.bor((readMem(A, ASize, 1048588, 32)), (bit.lshift(1, (bit.rshift(R, 2)))))), 32)
  FD = S
  else
 do 
	::FFStart::
 if checkCondition(((W < (bit.band((readMem(A, ASize, T, 32)), -4))) and 1 or 0)) then 
	::FGStart::
  T = (readMem(A, ASize, T, 32))
  if checkCondition((((readMem(A, ASize, T, 32)) ~= S) and 1 or 0)) then
      goto FFStart
  end
  else
  S = T
	::FGFinish::
  end
	::FFFinish::
  end
	::FEFinish::
   FD = (readMem(A, ASize, S, 32))
 end
  T = FD
  storeMem(A, ASize, V, T, 32)
  storeMem(A, ASize, V, S, 32)
  storeMem(A, ASize, FD, V, 32)
  storeMem(A, ASize, S, Q, 32)
	::EQFinish::
  end
	::DZFinish::
  end
	::DOFinish::
  end
 if checkCondition(((U > I) and 1 or 0)) then 
	::FHStart::
  I = U
	::FHFinish::
  end
  if checkCondition(((U <= J) and 1 or 0)) then
      goto DIFinish
  end
  J = U
	::DIFinish::
  end
  Q = (readMem(A, ASize, 1048592, 32))
  R = (bit.band((readMem(A, ASize, (readMem(A, ASize, 1048592, 32)), 32)), -4))
  U = ((bit.band((readMem(A, ASize, (readMem(A, ASize, 1048592, 32)), 32)), -4)) - P)
 if checkCondition(((R < P) and 1 or 0)) then 
	::FIStart::
  if true then return 0 end
	::FIFinish::
  end
  if checkCondition(((((bit.band((readMem(A, ASize, (readMem(A, ASize, 1048592, 32)), 32)), -4)) - P) >= 16) and 1 or 0)) then
      goto DDFinish
  end
  if true then return 0 end
	::DDFinish::
  end
  storeMem(A, ASize, Q, (bit.bor(P, 1)), 32)
  P = (P + Q)
  storeMem(A, ASize, 1048592, (P + Q), 32)
  storeMem(A, ASize, P, (bit.bor(U, 1)), 32)
  return (8 + Q)
end
function N()
  local FJ = 0
  local FK = 0
  local FL = imports.ccm1__string_new(1049616)
  FJ = FL
  local FM = imports.ccm1__string_from_cstr_to_value(1049628)
  imports.ccm1__string_log(FM)
  local FN = imports.ccm1__string_from_cstr_to_value(1049628)
  imports.ccm1__string_log(FN)
  imports.ccm1__string_log(FL)
  local FO = imports.ccm1__dynamic_string_new()
  FK = FO
  local FP = imports.ccm1__string_from_cstr_to_value(1049634)
  local FQ = imports.ccm1__dynamic_string_append(FO, FP)
  local FR = imports.ccm1__dynamic_string_append(FK, FJ)
  imports.ccm1__dynamic_string_log(FK)
  local FS = imports.ccm1__dynamic_string_join(FK)
  imports.ccm1__dynamic_string_log(FS)
  local FT = M(4)
  FJ = FT
  imports.MyValue__Ev(FT)
  FK = ((readMem(A, ASize, FJ, 32)) + 3)
  storeMem(A, ASize, FJ, FK, 32)
  return ((readMem(A, ASize, FJ, 32)) + 3)
end
exportTable.main = N
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
