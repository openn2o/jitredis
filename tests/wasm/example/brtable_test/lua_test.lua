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
