local IContestUsersRepo = require("domain.repos.IContestUsersRepo")

---@class app.ContestUsersRepo: domain.IContestUsersRepo
---@operator call: app.ContestUsersRepo
local ContestUsersRepo = IContestUsersRepo + {}

---@param appDatabase app.AppDatabase
function ContestUsersRepo:new(appDatabase)
	self.models = appDatabase.models
end

return ContestUsersRepo
