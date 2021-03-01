local function Fbnq1(n)
	if n < 1 then
		print(1)
	elseif n == 1 or n == 2 then
		--todo
		return 1
	else
		return Fbnq1(n - 1) + Fbnq1(n - 2)
	end
end

print(Fbnq1(40));
