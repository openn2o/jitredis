local bit = require("bit");
local ffi = require("ffi");
function F(G)
    do ::HStart::
    do ::IStart::
    do ::JStart:: 
    end end end
   ::JFinish::
    if (bit.band((G - 43), 255)) then goto HFinish end
    if true then return 62 end
  ::IFinish::
    if true then return 63 end
  ::HFinish::
  if (((bit.band(G, 255)) == 61) and 1 or 0) then goto IFinish end
    return 0, 64
  end


print(F(43))
print(F(47))
print(F(61))