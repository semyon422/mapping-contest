local class = require("class")

---@class app.ContestsRepo: domain.IContestsRepo
---@operator call: app.ContestsRepo
local ContestsRepo = class()

---@param appDatabase app.AppDatabase
function ContestsRepo:new(appDatabase)
	self.models = appDatabase.models
end

---@param contest_id number
---@return table?
function ContestsRepo:getContestById(contest_id)
	return self.models.contests:find({id = assert(contest_id)})
end

return ContestsRepo
