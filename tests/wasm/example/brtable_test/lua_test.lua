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
	if checkCondition((((bit.bor((H + -43), 4)) == 4) and 1 or 0)) then 
	   ::IStart::
	 if true then return (checkCondition(((H == 43) and 1 or 0)) and 62) or (63) end
	   ::IFinish::
	 end
	 return (checkCondition(((H == 61) and 1 or 0)) and 64) or (0)
   end
   function G(J)
	do 
	   ::KStart::
	do 
	   ::LStart::
	do 
	   ::MStart::
	   local eax=(J - 1)
	   local branch_tab = ffi.new('int[12]', {0,2,0,1,0,1,0,0,1,0,1,0})
	   if (eax < 12) then
	   eax=branch_tab[eax];
		if eax == 2 then
			goto KFinish
		end
		if eax == 1 then
			goto LFinish
		end
		if eax == 0 then
			goto MFinish
		end
	   else
			goto MFinish
	   end
	   ::MFinish::
	 end
	 if true then return 31 end
	   ::LFinish::
	 end
	 if true then return 30 end
	   ::KFinish::
	 end
	 return 28
   end

print(F(43))
print(F(47))
print(F(61))