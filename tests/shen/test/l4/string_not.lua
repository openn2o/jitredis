local a = "hello"
local b = nil


if not b then
	print_s("ok");
else
	print_s("failed");
end

if a then
	print_s("ok1");
end

if b  then
	print_s("ok2");
end