local function checkCondition(cond)
  return cond == true or (cond ~= false and cond ~= 0)
end
function F(G)
  local H = 0
  do ::IStart::
  do ::JStart::
  do ::KStart::
  do ::LStart::
	end -- brtable
	end -- brtable
	end -- brtable
	end -- brtable
::LFinish::
	if checkCondition((bit.band((G - 43), 255))) then goto IFinish end
 
    if true then return 62 end

::KFinish::
	 
    if true then return 63 end

::JFinish::
	 
    if true then return 64 end

::IFinish::
	 
    if checkCondition((((bit.band((G + 208), 255)) < 10) and 1 or 0)) then ::MStart::
  if true then return (G + 4) end

::MFinish::
	 
    H = (G + 191)
  if checkCondition((((bit.band((G + 191), 255)) < 26) and 1 or 0)) then ::NStart::
  if true then return H end

::NFinish::
	 
  if checkCondition((((bit.band((G + 159), 255)) < 26) and 1 or 0)) then 
		 --  0 
	 else 
		 goto KFinish 
	end
end
print(F(43));
print(F(47));
print(F(61));
print(F(61));
print(F(47));
print(F(58));



