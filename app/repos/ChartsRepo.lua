local IChartsRepo = require("domain.repos.IChartsRepo")

---@class app.ChartsRepo: domain.IChartsRepo
---@operator call: app.ChartsRepo
local ChartsRepo = IChartsRepo + {}

---@param appDatabase app.AppDatabase
function ChartsRepo:new(appDatabase)
	self.models = appDatabase.models
end

return ChartsRepo
