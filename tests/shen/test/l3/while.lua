
function out  ()
	local d = 0
	
	while d < 10 do
		print(d);
		d = d + 1;
	end
	
	return d;
end

print(out());