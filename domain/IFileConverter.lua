local class = require("class")

---@class domain.IFileConverter
---@operator call: domain.IFileConverter
local IFileConverter = class()

---@param filename string
---@param data string
---@return string
---@return string
function IFileConverter:convert(filename, data)
	return filename, data
end

return IFileConverter
