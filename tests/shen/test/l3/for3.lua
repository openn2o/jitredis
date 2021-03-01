
function out  ()
	local d = 0
	for i=1000000000,1,-1 do
		d = d + 2;
	end
	return d;
end

print(out());