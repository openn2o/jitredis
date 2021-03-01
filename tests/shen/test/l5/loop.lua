function a ()
	local a = 10087;
	return a;
end

function b ()
	local c = 10087;
	function c ()
	end
end


b();
local c = a();
return c;