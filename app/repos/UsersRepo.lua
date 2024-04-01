local IUsersRepo = require("domain.repos.IUsersRepo")
local Repo = require("app.repos.Repo")

---@class app.UsersRepo: app.Repo, domain.IUsersRepo
---@operator call: app.UsersRepo
local UsersRepo = Repo + IUsersRepo

UsersRepo.model_name = "users"

---@param user_name string
---@return table?
function UsersRepo:findByName(user_name)
	return self.models.users:find({name = assert(user_name)})
end

---@param osu_id number
---@return table?
function UsersRepo:findByOsuId(osu_id)
	return self.models.users:find({osu_id = assert(osu_id)})
end

return UsersRepo
