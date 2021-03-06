local function checkCondition(cond)
  return cond == true or (cond ~= false and cond ~= 0)
end
function F(J, K)
  return ((checkCondition(((J > K) and 1 or 0)) and J) or (K) * 100)
end
print(F(1,2));
print(F(1,200));
print(F(100,2));
local exportTable = {
}

function A(M)
  return (checkCondition(M == 0) and 2) or (1)
end
function B(N)
  return (checkCondition(N == 0) and 2) or (1)
end
function C(O)
  return (checkCondition(O == 0) and 2) or (1)
end
function D(P)
  return (checkCondition(P == 0) and 2) or (1)
end
function E()
  local Q = A(0)
  return Q
end
function F()
  local R = A(1)
  return R
end
function G()
  local S = B(0)
  return S
end
function H()
  local T = B(1)
  return T
end
function I()
  local U = C(0)
  return U
end
function J()
  local V = C(1)
  return V
end
function K()
  local W = D(0)
  return W
end
function L()
  local X = D(1)
  return X
end
exportTable.test_f32_l = I
exportTable.test_i64_r = H
exportTable.test_f64_r = L
exportTable.test_f32_r = J
exportTable.test_f64_l = K
exportTable.test_i32_r = F
exportTable.test_i32_l = E
exportTable.test_i64_l = G
print(exportTable.test_i32_l())
print(exportTable.test_i32_r())
print(exportTable.test_i64_l())
print(exportTable.test_i64_r())
print(exportTable.test_f32_l())
print(exportTable.test_f32_r())
print(exportTable.test_f64_l())
print(exportTable.test_f64_r())
