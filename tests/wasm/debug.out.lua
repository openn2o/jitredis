local imports = {console__log2 = 0,console__log = 0,console__log = 0,}
for k, v in pairs(imports) do
  imports[k] = function(...)
    print(...);
    -- return error("Unlinked function: '" .. k .. "'")
  end
end
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
local A = ffi.new("uint8_t[655360]")
local ASize = 10
local B = 0
local C = 0
local D = 0
local E = 0
local F = 0
A[8092] = 104
A[8093] = 101
A[8094] = 108
A[8095] = 108
A[8096] = 111
A[8097] = 119
A[8098] = 111
A[8099] = 114
A[8100] = 108
A[8101] = 100
A[8102] = 115
A[8103] = 97
A[8104] = 121
A[8105] = 50
A[8106] = 58
A[8107] = 32
A[8108] = 33
local G, H
function G(I, J, K)
  local L = 0
  local M = 0
  local N = 0
  local O = 0
  K = (I + K)
  do ::PStart::
  storeMem(A, ASize, I, (readMem(A, ASize, J, 8)), 32)
  I = (I + 1)
  J = (J + 1)
  if checkCondition(((I <= K) and 1 or 0)) then ::QStart::
 goto PStart
::QFinish::
    end
::PFinish::
    end
  return K
end
function H()
  local R = 0
  local S = 0
  local T = 0
  local U = 0
  local V = 0
  local W = 0
  local X = 0
  local Y = 0
  local Z = 0
  local BA = 0
  storeFloat(A, ASize, 0, 10000, 8)  storeFloat(A, ASize, 8, 1, 8)  storeFloat(A, ASize, 16, -1, 8)  storeFloat(A, ASize, 24, 0, 8)  do ::BBStart::
  storeFloat(A, ASize, 24, (ffi.cast("double*", A + 0)[0]), 8)  R = 32
  S = R
  local BC = G(S, 8102, 6)
  S = BC
  local BD = G(S, 8092, 5)
  S = BD
  local BE = G(S, 8097, 5)
  S = BE
  local BF = G(S, 8108, 1)
  S = BF
  S = 17
  imports.console__log2(32, 17)
  Y = (((ffi.cast("double*", A + 0)[0]) ~= (ffi.cast("double*", A + 8)[0])) and 1 or 0)
  storeFloat(A, ASize, 0, ((ffi.cast("double*", A + 0)[0]) + (ffi.cast("double*", A + 16)[0])), 8)  if checkCondition(Y) then ::BGStart::
 goto BBStart
::BGFinish::
    end
::BBFinish::
    end
  if true then return 0 end
end
exportTable.main = H
exportTable.mem = A
if exportTable.main ~= nil then
  print(exportTable.main());
end

return { exports = exportTable, importTable = imports, }
