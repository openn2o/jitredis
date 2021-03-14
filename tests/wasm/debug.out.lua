local ccm1 = require("ccm1_string");
local imports = {ccm1__string_new = ccm1.ccm1__string_new
,ccm1__string_from_cstr_to_value = ccm1.ccm1__string_from_cstr_to_value
,ccm1__string_log = ccm1.ccm1__string_log
,ccm1__dynamic_string_new = ccm1.ccm1__dynamic_string_new
,ccm1__dynamic_string_append = ccm1.ccm1__dynamic_string_append
,ccm1__dynamic_string_log = ccm1.ccm1__dynamic_string_log
,ccm1__dynamic_string_join = ccm1.ccm1__dynamic_string_join
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
A[1048596] = 104
A[1048597] = 101
A[1048598] = 108
A[1048599] = 108
A[1048600] = 111
A[1048601] = 0
A[1048602] = 105
A[1048603] = 32
A[1048604] = 97
A[1048605] = 109
A[1048606] = 32
A[1048607] = 99
A[1048608] = 111
A[1048609] = 110
A[1048610] = 115
A[1048611] = 116
A[1048612] = 50
A[1048613] = 44
local D, E
function D()
  error("Unreachable code reached..", 2)
end
function E()
  local F = 0
  local G = 0
  local H = imports.ccm1__string_new(1048584)
  F = H
  local I = imports.ccm1__string_from_cstr_to_value(1048596)
  imports.ccm1__string_log(I)
  local J = imports.ccm1__string_from_cstr_to_value(1048596)
  imports.ccm1__string_log(J)
  imports.ccm1__string_log(H)
  local K = imports.ccm1__dynamic_string_new()
  G = K
  local L = imports.ccm1__string_from_cstr_to_value(1048602)
  local M = imports.ccm1__dynamic_string_append(K, L)
  local N = imports.ccm1__dynamic_string_append(G, F)
  imports.ccm1__dynamic_string_log(G)
  local O = imports.ccm1__dynamic_string_join(G)
  imports.ccm1__dynamic_string_log(O)
  return 0
end
exportTable.main = E
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
