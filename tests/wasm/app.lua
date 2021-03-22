local lib = require("lib");

if lib.exports.main ~= nil then
    if lib.importTable then
        for k, v in pairs(lib.importTable.requires) do
            v.bytes = lib.exports.memory;
        end
    end
    print(lib.exports.main());
end


