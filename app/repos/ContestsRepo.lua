local IContestsRepo = require("domain.repos.IContestsRepo")

---@class app.ContestsRepo: domain.IContestsRepo
---@operator call: app.ContestsRepo
local ContestsRepo = IContestsRepo + {}

---@param appDatabase app.AppDatabase
function ContestsRepo:new(appDatabase)
	self.models = appDatabase.models
end

---@param contest_id number
---@return table?
function ContestsRepo:getById(contest_id)
	return self.models.contests:find({id = assert(contest_id)})
end

---@return table?
function ContestsRepo:getAll()
	return self.models.contests:select()
end

return ContestsRepo
