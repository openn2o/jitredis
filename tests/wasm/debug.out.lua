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
function F(H)
  local I = 0
 if checkCondition((((bit.bor((H + -43), 4)) == 4) and 1 or 0)) then 
	::JStart::
  if true then return (checkCondition(((H == 43) and 1 or 0)) and 62) or (63) end
	::JFinish::
  end
 if checkCondition(((H == 61) and 1 or 0)) then 
	::KStart::
  if true then return 64 end
	::KFinish::
  end
 if checkCondition((((H + -48) < 10) and 1 or 0)) then 
	::LStart::
  if true then return (H + 4) end
	::LFinish::
  end
  I = (H + -65)
 if checkCondition((((H + -65) < 26) and 1 or 0)) then 
	::MStart::
  if true then return I end
	::MFinish::
  end
  return (checkCondition((((H + -97) < 26) and 1 or 0)) and (H + -71)) or (0)
end
function G(N)
 do 
	::OStart::
 do 
	::PStart::
 do 
	::QStart::
	local eax=(N - 1)
	local branch_tab = ffi.new('int[12]', {0,2,0,1,0,1,0,0,1,0,1,0})
	if (eax < 12) then
	eax=branch_tab[eax];
	 if eax == 2 then
		 goto OFinish
	 end
	 if eax == 1 then
		 goto PFinish
	 end
	 if eax == 0 then
		 goto QFinish
	 end
	else
		 goto QFinish
	end
	::QFinish::
  end
  if true then return 31 end
	::PFinish::
  end
  if true then return 30 end
	::OFinish::
  end
  return 28
end
exportTable.k = E
exportTable.M = A
exportTable.j = G
exportTable.i = F
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
