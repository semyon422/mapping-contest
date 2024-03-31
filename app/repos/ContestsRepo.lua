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

---@param contest_id number
function ContestsRepo:deleteById(contest_id)
	return self.models.contests:delete({id = assert(contest_id)})
end

---@return table?
function ContestsRepo:getAll()
	return self.models.contests:select()
end

---@param contest table
function ContestsRepo:update(contest)
	return self.models.contests:update(contest, {id = assert(contest.id)})
end

---@param contest table
function ContestsRepo:create(contest)
	return self.models.contests:create(contest)
end

return ContestsRepo
