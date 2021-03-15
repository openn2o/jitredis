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
local A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, BA, BB, BC, BD, BE, BF, BG, BH, BI, BJ, BK, BL, BM, BN, BO, BP, BQ, BR
function A()
  return (1 + 2)
end
function B()
  return (20 - 4)
end
function C()
  return (3 * 7)
end
function D()
  return (math.floor(-4 / 2))
end
function E()
  return (math.abs(math.floor(-4 / 2)))
end
function F()
  return (math.floor(-5 % 2))
end
function G()
  return (math.floor(-5 % 2))
end
function H()
  return (bit.band(11, 5))
end
function I()
  return (bit.bor(11, 5))
end
function J()
  return (bit.bxor(11, 5))
end
function K()
  return (bit.lshift(-100, 3))
end
function L()
  return (bit.rshift(-100, 3))
end
function M()
  return (bit.arshift(-100, 3))
end
function N()
  return (bit.rol(-100, 3))
end
function O()
  return (bit.ror(-100, 3))
end
function P()
  return (1 + 2)
end
function Q()
  return (20 - 4)
end
function R()
  return (3 * 7)
end
function S()
  return (math.floor(-4 / 2))
end
function T()
  return (math.abs(math.floor(-4 / 2)))
end
function U()
  return (math.floor(-5 % 2))
end
function V()
  return (math.floor(-5 % 2))
end
function W()
  return (bit.band(11, 5))
end
function X()
  return (bit.bor(11, 5))
end
function Y()
  return (bit.bxor(11, 5))
end
function Z()
  return (bit.lshift(-100, 3))
end
function BA()
  return (bit.rshift(-100, 3))
end
function BB()
  return (bit.rshift(-100, 3))
end
function BC()
  return (bit.rol(-100, 3))
end
function BD()
  return (bit.rol(-100, 3))
end
function BE()
  return (1.25 + 3.75)
end
function BF()
  return (4.5 - 10000)
end
function BG()
  return (1234.5 * -6.875)
end
function BH()
  return (math.floor(1.0000000037683e+14 / -200000))
end
function BI()
  return math.min(0, 0)
end
function BJ()
  return math.min(0, 0)
end
function BK()
  return 0, 0
end
function BL()
  return (987654321 + 123456789)
end
function BM()
  return (1.234e+59 - 5.5e+23)
end
function BN()
  return (-1230000 * 12341234)
end
function BO()
  return (1e+200 / 1e+50)
end
function BP()
  return math.min(0, 0)
end
function BQ()
  return math.max(0, 0)
end
function BR()
  return 0, 0
end
exportTable.i32_rotl = N
exportTable.i64_mul = R
exportTable.f64_copysign = BR
exportTable.i64_sub = Q
exportTable.i64_rem_u = V
exportTable.i64_div_u = T
exportTable.i32_shr_s = M
exportTable.f64_max = BQ
exportTable.i32_or = I
exportTable.i32_rotr = O
exportTable.i64_shr_s = BB
exportTable.i32_div_u = E
exportTable.f32_copysign = BK
exportTable.i32_sub = B
exportTable.f32_add = BE
exportTable.i32_add = A
exportTable.i32_xor = J
exportTable.i64_div_s = S
exportTable.f32_min = BI
exportTable.f32_sub = BF
exportTable.i32_div_s = D
exportTable.f64_div = BO
exportTable.i32_shl = K
exportTable.f32_mul = BG
exportTable.i64_or = X
exportTable.i64_and = W
exportTable.f64_add = BL
exportTable.i64_rotr = BD
exportTable.f32_max = BJ
exportTable.i64_add = P
exportTable.i64_xor = Y
exportTable.f32_div = BH
exportTable.f64_min = BP
exportTable.i32_rem_u = G
exportTable.i32_and = H
exportTable.f64_sub = BM
exportTable.i64_rem_s = U
exportTable.i32_rem_s = F
exportTable.f64_mul = BN
exportTable.i32_mul = C
exportTable.i64_shr_u = BA
exportTable.i64_rotl = BC
exportTable.i64_shl = Z
exportTable.i32_shr_u = L
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
