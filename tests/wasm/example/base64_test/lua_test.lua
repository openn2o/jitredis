local bit = require("bit");
local ffi = require("ffi");
local function checkCondition(cond)
  return cond == true or (cond ~= false and cond ~= 0)
end

function F(G)
  do ::HStart::
  do ::IStart::
  do ::JStart::
	local eax=(G - 1)
	local branch_tab = ffi.new('int[12]', {0,2,0,1,0,1,0,0,1,0,1,0})
	if (eax < 12) then
	eax=branch_tab[eax];
	 if eax == 2 then
		 goto HFinish
	 end
	 if eax == 1 then
		 goto IFinish
	 end
	 if eax == 0 then
		 goto JFinish
	 end
	else
		 goto JFinish
	end
::JFinish::
  end
  if true then return 31 end
::IFinish::
  end
  if true then return 30 end
::HFinish::
  end
  return 28
end
print(F(1))
print(F(2))
print(F(3))
print(F(4))
print(F(5))
print(F(6))
print(F(7))
print(F(8))
print(F(9))
print(F(10))
print(F(11))
print(F(12))

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
print(F(43))
print(F(47))
print(F(61))
print(F(48))
print(F(49))
print(F(50))
print(F(65))
print(F(66))
print(F(97))
print(F(98))

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
  function G(Q)
	do 
	   ::RStart::
	do 
	   ::SStart::
	do 
	   ::TStart::
	   local eax=(Q - 1)
	   local branch_tab = ffi.new('int[12]', {0,2,0,1,0,1,0,0,1,0,1,0})
	   if (eax < 12) then
	   eax=branch_tab[eax];
		if eax == 2 then
			goto RFinish
		end
		if eax == 1 then
			goto SFinish
		end
		if eax == 0 then
			goto TFinish
		end
	   else
			goto TFinish
	   end
	   ::TFinish::
	 end
	 if true then return 31 end
	   ::SFinish::
	 end
	 if true then return 30 end
	   ::RFinish::
	 end
	 return 29
   end
print(E(40))
print(G(1))
print(G(2))
print(G(3))
print(G(4))
print(G(5))
print(G(6))
print(G(7))
print(G(8))
print(G(9))
print(G(10))
print(G(11))
print(G(12))