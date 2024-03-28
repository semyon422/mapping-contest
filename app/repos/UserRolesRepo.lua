local IUserRolesRepo = require("domain.repos.IUserRolesRepo")

---@class app.UserRolesRepo: domain.IUserRolesRepo
---@operator call: app.UserRolesRepo
local UserRolesRepo = IUserRolesRepo + {}

---@param appDatabase app.AppDatabase
function UserRolesRepo:new(appDatabase)
	self.models = appDatabase.models
end

function UserRolesRepo:deleteByIdRole(user_id, role)
	self.models.user_roles:delete({
		user_id = assert(user_id),
		role = assert(role),
	})
end

return UserRolesRepo
