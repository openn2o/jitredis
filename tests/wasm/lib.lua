local ccm1 = require("ccm1_string");
local imports = {ccm1__log = ccm1.ccm1__log
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
local function storeMem(mem, memSize, addr, val, bytes, type)
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to store outside bounds", 2)
  end
  if bytes == 8 then
    ffi.cast("uint" .. bytes .. "_t*", mem + addr)[0] = val
  else
    if type == 1 then
      ffi.cast("int" .. bytes .. "_t*", mem + addr)[0] = val
    end
    
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
---debug10081
local brtable_mems_002 = {
  4294967295, 
  0,
  0,
  4294967295,
  65535,
  0,
  0,
  65535,
  4294967295
}
local function readMem(mem, memSize, addr, bytes, type)
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to read outside bounds " .. addr, 2)
  end
  if bytes == 8 then
    local m =  ffi.cast("uint" .. bytes .. "_t*", mem + addr)[0];
    if type == 2 then
      --i32.load8s
      if 127 < m then
         return  4294967295;
      end
    end
    if type == 6 then
      --i64.load8s
      if m > 127 then
        return 18446744073709551615;
      end
    end

    if type == 7 then
      if m > 255 then
        return 255;
      end
    end
    return m;
  else
    local m = ffi.cast("int" .. bytes .. "_t*", mem + addr)[0];
    if m < 0 then
      return brtable_mems_002[type];
    end
    return  m;
  end
end
local exportTable = {}
local A = ffi.new("uint8_t[2097152]")
local ASize = 32
local B = 1048576
local C = {  }
local D, E, F
function D()
  error("Unreachable code reached..", 2)
end
function E(G)
  local H = 0
  local I = 0
  local J = 0
  I = (G + -1)
 if checkCondition((((G + -1) < 2) and 1 or 0)) then 
	::KStart::
  if true then return 1 end
	::KFinish::
  end
  J = 1
  H = G
 do 
	::LStart::
  local M = E(I)
  J = (M + J)
  I = (H + -3)
 if checkCondition((((H + -3) < 2) and 1 or 0)) then 
	::NStart::
  if true then return J end
	::NFinish::
  end
  H = (H + -2)
 goto LStart
	::LFinish::
  end
  return 0
end
function F()
  imports.ccm1__log(1)
  local O = E(3)
  imports.ccm1__log(O)
  local P = E(4)
  imports.ccm1__log(P)
  local Q = E(5)
  imports.ccm1__log(Q)
  local R = E(6)
  imports.ccm1__log(R)
  local S = E(7)
  imports.ccm1__log(S)
  local T = E(8)
  imports.ccm1__log(T)
  local U = E(9)
  imports.ccm1__log(U)
  local V = E(10)
  imports.ccm1__log(V)
  local W = E(11)
  imports.ccm1__log(W)
  local X = E(12)
  imports.ccm1__log(X)
  local Y = E(13)
  imports.ccm1__log(Y)
  local Z = E(14)
  imports.ccm1__log(Z)
  local BA = E(15)
  imports.ccm1__log(BA)
  local BB = E(16)
  imports.ccm1__log(BB)
  local BC = E(17)
  imports.ccm1__log(BC)
  local BD = E(18)
  imports.ccm1__log(BD)
  local BE = E(19)
  imports.ccm1__log(BE)
  local BF = E(20)
  imports.ccm1__log(BF)
  local BG = E(21)
  imports.ccm1__log(BG)
  local BH = E(22)
  imports.ccm1__log(BH)
  local BI = E(23)
  imports.ccm1__log(BI)
  local BJ = E(24)
  imports.ccm1__log(BJ)
  local BK = E(25)
  imports.ccm1__log(BK)
  local BL = E(26)
  imports.ccm1__log(BL)
  local BM = E(27)
  imports.ccm1__log(BM)
  local BN = E(28)
  imports.ccm1__log(BN)
  local BO = E(29)
  imports.ccm1__log(BO)
  local BP = E(30)
  imports.ccm1__log(BP)
  local BQ = E(31)
  imports.ccm1__log(BQ)
  local BR = E(32)
  imports.ccm1__log(BR)
  local BS = E(33)
  imports.ccm1__log(BS)
  local BT = E(34)
  imports.ccm1__log(BT)
  local BU = E(35)
  imports.ccm1__log(BU)
  local BV = E(36)
  imports.ccm1__log(BV)
  local BW = E(37)
  imports.ccm1__log(BW)
  local BX = E(38)
  imports.ccm1__log(BX)
  local BY = E(39)
  imports.ccm1__log(BY)
  local BZ = E(40)
  imports.ccm1__log(BZ)
  return 0
end
exportTable.main = F
exportTable.fab = E
exportTable.memory = A
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
