local ITracksRepo = require("domain.repos.ITracksRepo")

---@class app.TracksRepo: domain.ITracksRepo
---@operator call: app.TracksRepo
local TracksRepo = ITracksRepo + {}

---@param appDatabase app.AppDatabase
function TracksRepo:new(appDatabase)
	self.models = appDatabase.models
end

return TracksRepo
