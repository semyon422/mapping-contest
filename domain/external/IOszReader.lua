local class = require("class")

---@class domain.IOszReader
---@operator call: domain.IOszReader
local IOszReader = class()

---@param file table
---@return table
function IOszReader:read(file)
	return {}
end

return IOszReader
