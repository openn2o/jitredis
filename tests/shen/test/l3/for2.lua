
function out  ()
	local d = 0
	for i=10,1,-1 do
		print(i)
		d = d + 1;
	end
	return d;
end

print(out());