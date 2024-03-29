local IUsersRepo = require("domain.repos.IUsersRepo")

---@class app.UsersRepo: domain.IUsersRepo
---@operator call: app.UsersRepo
local UsersRepo = IUsersRepo + {}

---@param appDatabase app.AppDatabase
function UsersRepo:new(appDatabase)
	self.models = appDatabase.models
end

---@param user_id number
---@return table?
function UsersRepo:getById(user_id)
	return self.models.users:find({id = assert(user_id)})
end

---@param user_name string
---@return table?
function UsersRepo:getByName(user_name)
	return self.models.users:find({name = assert(user_name)})
end

---@param osu_id number
---@return table?
function UsersRepo:getByOsuId(osu_id)
	return self.models.users:find({osu_id = assert(osu_id)})
end

---@return table?
function UsersRepo:getAll()
	return self.models.users:select()
end

return UsersRepo
