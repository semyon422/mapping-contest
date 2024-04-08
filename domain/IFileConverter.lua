local class = require("class")

---@class domain.IFileConverter
---@operator call: domain.IFileConverter
local IFileConverter = class()

---@param files table
---@param options table
---@return table
function IFileConverter:convert(files, options)
	return {}
end

return IFileConverter
