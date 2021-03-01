local isub = string.gsub;
local str_req = "\\/aaaa\\/2222//cccc\\ccc\\\""
print(str_req);
str_req = isub(str_req, "%\\%/", "%/");
print(str_req);