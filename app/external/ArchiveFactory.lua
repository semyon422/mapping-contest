local minizip = require("minizip")
local IArchiveFactory = require("domain.external.IArchiveFactory")
local Archive = require("app.external.Archive")

---@class app.ArchiveFactory: domain.IArchiveFactory
---@operator call: app.ArchiveFactory
local ArchiveFactory = IArchiveFactory + {}

---@param path string
---@param mode string
---@return app.Archive
function ArchiveFactory:open(path, mode)
	local zip = minizip.open(path, mode)
	return Archive(zip)
end

return ArchiveFactory
