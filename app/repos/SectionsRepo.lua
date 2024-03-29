local ISectionsRepo = require("domain.repos.ISectionsRepo")

---@class app.SectionsRepo: domain.ISectionsRepo
---@operator call: app.SectionsRepo
local SectionsRepo = ISectionsRepo + {}

---@param appDatabase app.AppDatabase
function SectionsRepo:new(appDatabase)
	self.models = appDatabase.models
end

return SectionsRepo
