local IRepo = require("domain.repos.IRepo")

---@class domain.IUserRolesRepo: domain.IRepo
---@operator call: domain.IUserRolesRepo
local IUserRolesRepo = IRepo + {}

function IUserRolesRepo:deleteByIdRole(user_id, role)
end

return IUserRolesRepo
