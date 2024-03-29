local IContestTracksRepo = require("domain.repos.IContestTracksRepo")

---@class app.ContestTracksRepo: domain.IContestTracksRepo
---@operator call: app.ContestTracksRepo
local ContestTracksRepo = IContestTracksRepo + {}

---@param appDatabase app.AppDatabase
function ContestTracksRepo:new(appDatabase)
	self.models = appDatabase.models
end

return ContestTracksRepo
