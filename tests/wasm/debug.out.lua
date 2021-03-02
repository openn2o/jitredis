local imports = {i____ZN6client5printEi = 0,}
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
  return 0
end
function F(G, H)
  local I = 0
  local J = 0
  local K = 0
  I = B
  K = (-8 + I)
  B = (-8 + I)
  storeMem(A, ASize, K, G, 32)
  if checkCondition(((H > 0) and 1 or 0)) then ::LStart::
  K = (4 + K)
  J = ((4 + K) + H)
  do ::MStart::
  imports.i____ZN6client5printEi(K)
  K = (K + 1)
  if checkCondition((((K + 1) < J) and 1 or 0)) then
      goto MStart
  end
::MFinish::
    end
::LFinish::
    end
  B = B
end
exportTable._main = E
exportTable.__Z19get_module_version2ii = F
exportTable.memory = A
if exportTable.main ~= nil then
  print(exportTable.main());
end
if exportTable._main ~= nil then
  print(exportTable._main());
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
