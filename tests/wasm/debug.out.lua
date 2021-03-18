local imports = {}
for k, v in pairs(imports) do
  if not imports[k] then
    imports[k] = function(...)
      print("Unlinked Method " .. k);
    end
  end
end
if not imports then imports = {} end 
imports.requires = {}

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
exportTable.memory = A
local B = 1048576
local C = {  }
local D, E, F
function D()
  error("Unreachable code reached..", 2)
end
function E()
  return 0
end
function F(G, H)
 do 
	::IStart::
 do 
	::JStart::
 do 
	::KStart::
	local eax=(H - 5)
	local branch_tab = ffi.new('int[8]', {0,2,2,2,2,2,2,1})
	if (eax < 8) then
	eax=branch_tab[eax];
	 if eax == 2 then
		 goto IFinish
	 end
	 if eax == 1 then
		 goto JFinish
	 end
	 if eax == 0 then
		 goto KFinish
	 end
	else
		 goto KFinish
	end
	::KFinish::
  end
  if true then return 1 end
	::JFinish::
  end
  if true then return 2 end
	::IFinish::
  end
  return (checkCondition(((G == 1) and 1 or 0)) and 2) or ((checkCondition(((G == 2) and 1 or 0)) and 3) or (5))
end
exportTable.br_table_muli = F
exportTable.memory = A
exportTable.main = E
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
