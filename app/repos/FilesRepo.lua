local IFilesRepo = require("domain.repos.IFilesRepo")

---@class app.FilesRepo: domain.IFilesRepo
---@operator call: app.FilesRepo
local FilesRepo = IFilesRepo + {}

---@param appDatabase app.AppDatabase
function FilesRepo:new(appDatabase)
	self.models = appDatabase.models
end

return FilesRepo
