local imports = {ccm1__string_from_value_to_cstr = 0,}
for k, v in pairs(imports) do
  if not imports[k] then
    imports[k] = function(...)
      print("Unlinked Method " .. k);
    end
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
local A = ffi.new("uint8_t[1114112]")
local ASize = 17
exportTable.memory = A
local B = 1048576
local C = {  }
local D, E, F, G
function D()
  error("Unreachable code reached..", 2)
end
function E()
  return 0
end
function F(H, I)
  local J = 0
  local K = 0
  local L = 0
  local M = 0
  local N = 0
  local O = imports.ccm1__string_from_value_to_cstr(H, I)
  K = O
 if checkCondition(((I > 3) and 1 or 0)) then 
	::PStart::
  N = K
  L = I
  M = I
 do 
	::QStart::
  M = (M + -4)
  J = ((bit.bor((bit.bor((bit.bor((bit.lshift((readMem(A, ASize, N, 8)), 8)), (readMem(A, ASize, N, 8)))), (bit.lshift((readMem(A, ASize, N, 8)), 16)))), (bit.lshift((readMem(A, ASize, N, 8)), 24)))) * 1540483477)
  L = (bit.bxor(((bit.bxor((bit.arshift(((bit.bor((bit.bor((bit.bor((bit.lshift((readMem(A, ASize, N, 8)), 8)), (readMem(A, ASize, N, 8)))), (bit.lshift((readMem(A, ASize, N, 8)), 16)))), (bit.lshift((readMem(A, ASize, N, 8)), 24)))) * 1540483477), 24)), J)) * 1540483477), (L * 1540483477)))
 if checkCondition((((M + -4) > 3) and 1 or 0)) then 
	::RStart::
  N = (4 + N)
 goto QStart
	::RFinish::
  end
	::QFinish::
  end
  M = (I + -4)
  N = (bit.band((I + -4), -4))
  K = (4 + (N + K))
  M = (M - N)
  else
  M = I
  L = I
	::PFinish::
  end
 do 
	::SStart::
 do 
	::TStart::
 if checkCondition((((M + -1) < 2) and 1 or 0)) then 
	::UStart::
  if checkCondition(((M == 1) and 1 or 0)) then
      goto TFinish
  end
  else
  if checkCondition(((M ~= 3) and 1 or 0)) then
      goto SFinish
  end
  L = (bit.bxor((bit.lshift((readMem(A, ASize, K, 8)), 16)), L))
	::UFinish::
  end
  L = (bit.bxor((bit.lshift((readMem(A, ASize, K, 8)), 8)), L))
	::TFinish::
  end
  L = ((bit.bxor((readMem(A, ASize, K, 8)), L)) * 1540483477)
	::SFinish::
  end
  K = ((bit.bxor((bit.arshift(L, 13)), L)) * 1540483477)
  return (bit.bxor((bit.arshift(((bit.bxor((bit.arshift(L, 13)), L)) * 1540483477), 15)), K))
end
function G(V, W)
  local X = 0
  local Y = 0
  local Z = 0
  local BA = imports.ccm1__string_from_value_to_cstr(V, W)
  X = BA
  Y = (readMem(A, ASize, BA, 8))
 if checkCondition((((readMem(A, ASize, BA, 8)) == 0) and 1 or 0)) then 
	::BBStart::
  if true then return 5381 end
	::BBFinish::
  end
  Z = 5381
 do 
	::BCStart::
  Z = ((Z * 33) + (bit.arshift((bit.lshift(Y, 24)), 24)))
  Y = (readMem(A, ASize, X, 8))
 if checkCondition((readMem(A, ASize, X, 8))) then 
	::BDStart::
  X = (1 + X)
 goto BCStart
	::BDFinish::
  end
	::BCFinish::
  end
  return (bit.band(Z, 2147483647))
end
exportTable.main = E
exportTable.murmur_hash2 = F
exportTable.djb_hash = G
exportTable.memory = A
if exportTable.main ~= nil then
  print(exportTable.main());
end
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
