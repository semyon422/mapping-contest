local class = require("class")

---@class domain.IArchiveFactory
---@operator call: domain.IArchiveFactory
local IArchiveFactory = class()

---@param path string
---@param mode string
---@return domain.IArchive
function IArchiveFactory:open(path, mode)
	return {}
end

return IArchiveFactory
