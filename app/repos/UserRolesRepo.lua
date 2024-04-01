local IUserRolesRepo = require("domain.repos.IUserRolesRepo")
local Repo = require("app.repos.Repo")

---@class app.UserRolesRepo: app.Repo, domain.IUserRolesRepo
---@operator call: app.UserRolesRepo
local UserRolesRepo = Repo + IUserRolesRepo

UserRolesRepo.model_name = "user_roles"

function UserRolesRepo:give(user_id, role)
	self.model:create({
		user_id = assert(user_id),
		role = assert(role),
	})
end

function UserRolesRepo:take(user_id, role)
	self.model:delete({
		user_id = assert(user_id),
		role = assert(role),
	})
end

return UserRolesRepo
