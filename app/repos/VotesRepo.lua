local IVotesRepo = require("domain.repos.IVotesRepo")

---@class app.VotesRepo: domain.IVotesRepo
---@operator call: app.VotesRepo
local VotesRepo = IVotesRepo + {}

---@param appDatabase app.AppDatabase
function VotesRepo:new(appDatabase)
	self.models = appDatabase.models
end

return VotesRepo
