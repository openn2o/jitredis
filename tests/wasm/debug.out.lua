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
function E(H)
  local I = 0
  local J = 0
  local K = 0
  J = (H + -1)
 if checkCondition((((H + -1) < 2) and 1 or 0)) then 
	::LStart::
  if true then return 1 end
	::LFinish::
  end
  K = 1
  I = H
 do 
	::MStart::
  local N = E(J)
  K = (N + K)
  J = (I + -3)
 if checkCondition((((I + -3) < 2) and 1 or 0)) then 
	::OStart::
  if true then return K end
	::OFinish::
  end
  I = (I + -2)
 goto MStart
	::MFinish::
  end
  return 0
end
function F()
  return 0
end
function G(P)
 do 
	::QStart::
 do 
	::RStart::
 do 
	::SStart::
	local eax=(P - 1)
	local branch_tab = ffi.new('int[12]', {0,2,0,1,0,1,0,0,1,0,1,0})
	if (eax < 12) then
	eax=branch_tab[eax];
	 if eax == 2 then
		 goto QFinish
	 end
	 if eax == 1 then
		 goto RFinish
	 end
	 if eax == 0 then
		 goto SFinish
	 end
	else
		 goto SFinish
	end
	::SFinish::
  end
  if true then return 31 end
	::RFinish::
  end
  if true then return 30 end
	::QFinish::
  end
  return 28
end
exportTable.i = E
exportTable.m = G
exportTable.l = F
exportTable.N = A
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
