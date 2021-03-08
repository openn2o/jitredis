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
local D, E, F
function D()
  error("Unreachable code reached..", 2)
end
function E()
  error("Unreachable code reached..", 2)
  error("Unreachable code reached..", 2)
end
function F(G, H, I)
  local J = 0
  local K = 0
  local L = 0
  local M = 0
  local N = 0
  local O = 0
  local P = 0
  local Q = 0
  local R = 0
  J = B
  M = (B + -16)
  B = (B + -16)
  M = M
  K = M
 if checkCondition(((H == 0) and 1 or 0)) then 
	::SStart::
  B = J
  if true then return 0 end
	::SFinish::
  end
  N = 0
  O = 0
  P = 0
 do 
	::TStart::
  L = (readMem(A, ASize, (P + G), 8))
 do 
	::UStart::
 do 
	::VStart::
 do 
	::WStart::
 do 
	::XStart::
 do 
	::YStart::
	local eax=(L - 43)
	local branch_tab = ffi.new('int[19]', {0,3,3,3,1,3,3,3,3,3,3,3,3,3,3,3,3,3,2})
	if (eax < 19) then
	eax=branch_tab[eax];
	 if eax == 3 then
		 goto TFinish
	 end
	 if eax == 2 then
		 goto UFinish
	 end
	 if eax == 1 then
		 goto VFinish
	 end
	 if eax == 0 then
		 goto WFinish
	 end
	else
		 goto WFinish
	end
	::YFinish::
  end
  R = 62
 goto UFinish
	::XFinish::
  end
  R = 63
 goto UFinish
	::WFinish::
  end
  R = 64
 goto UFinish
	::VFinish::
  end
 if checkCondition((((L + -48) < 10) and 1 or 0)) then 
	::ZStart::
  R = (L + 4)
  else
  R = (L + -65)
 if checkCondition((((L + -65) >= 26) and 1 or 0)) then 
	::BAStart::
  R = (checkCondition((((L + -97) < 26) and 1 or 0)) and (L + -71)) or (0)
	::BAFinish::
  end
	::ZFinish::
  end
	::UFinish::
  end
  storeMem(A, ASize, ((bit.lshift(O, 2)) + M), R, 32)
  O = (O + 1)
 if checkCondition((((O + 1) == 4) and 1 or 0)) then 
	::BBStart::
  O = (readMem(A, ASize, M, 32))
  storeMem(A, ASize, (N + I), ((bit.band((bit.rshift(O, 4)), 3)) + (bit.lshift((readMem(A, ASize, K, 32)), 2))), 8)
  Q = (readMem(A, ASize, M, 32))
 if checkCondition((((readMem(A, ASize, M, 32)) == 64) and 1 or 0)) then 
	::BCStart::
  O = 1
  else
  storeMem(A, ASize, (N + I), ((bit.band((bit.rshift(Q, 2)), 15)) + (bit.lshift(O, 4))), 8)
  O = (readMem(A, ASize, M, 32))
 if checkCondition((((readMem(A, ASize, M, 32)) == 64) and 1 or 0)) then 
	::BDStart::
  O = 2
  else
  storeMem(A, ASize, (N + I), (O + (bit.lshift(Q, 6))), 8)
  O = 3
	::BDFinish::
  end
	::BCFinish::
  end
  N = (O + N)
  O = 0
	::BBFinish::
  end
  P = (P + 1)
  if checkCondition((((P + 1) ~= H) and 1 or 0)) then
      goto TStart
  end
	::TFinish::
  end
  B = J
  return N
end
exportTable.b64_decode = F
exportTable.memory = A
exportTable.main = E
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

return { exports = exportTable, }
