local IRepo = require("domain.repos.IRepo")

---@class domain.IUserRolesRepo: domain.IRepo
---@operator call: domain.IUserRolesRepo
local IUserRolesRepo = IRepo + {}

function IUserRolesRepo:give(user_id, role)
end

function IUserRolesRepo:take(user_id, role)
end

return IUserRolesRepo
