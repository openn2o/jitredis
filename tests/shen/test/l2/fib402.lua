function Fbnq1(n)
	if n <= 2 then
		return 1;
	end
	return Fbnq1(n - 1) + Fbnq1(n - 2)
end

print(Fbnq1(40));
