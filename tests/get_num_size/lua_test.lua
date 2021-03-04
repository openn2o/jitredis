local bit = require("bit");
local ffi = require("ffi");
function F(G)
    do ::HStart::
    do ::IStart::
    do ::JStart::
  ::JFinish::
    if (bit.band((G - 43), 255)) then goto IFinish end
    end
    if true then return 62 end
  ::IFinish::
    if ((bit.band(G, 255)) == 61)  then
        goto HFinish
    end
      end
    if true then return 63 end
  ::HFinish::
      end
    return  64
end


print(F(43))
print(F(47))
print(F(61))