local function checkCondition(cond)
  return cond == true or (cond ~= false and cond ~= 0)
end
function F(G)
  do ::HStart::
  do ::IStart::
  do ::JStart::
	end -- brtable
	end -- brtable
	end -- brtable
::JFinish::
	if checkCondition((bit.band((G - 43), 255))) then goto HFinish end
  -- end
    if true then return 62 end

::IFinish::
	  -- end
    if true then return 63 end

::HFinish::
	  -- end
  if checkCondition((((bit.band(G, 255)) == 61) and 1 or 0)) then 
		 --  0 
	 else 
		 goto IFinish 
	end
  return 64
end

print(F(43));
print(F(47));
print(F(61));
print(F(61));


