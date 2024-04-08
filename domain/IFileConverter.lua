local class = require("class")

---@class domain.IFileConverter
---@operator call: domain.IFileConverter
local IFileConverter = class()

---@param files table
---@return table
function IFileConverter:convert(files)
	return {}
end

return IFileConverter
