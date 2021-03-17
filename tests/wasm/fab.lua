function fab(n) 
    if (n == 1) or (n==2) then
        return 1;
    end
    return fab(n-1) + fab(n-2);
end

print(fab(40));