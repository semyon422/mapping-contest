local IRepo = require("domain.repos.IRepo")

---@class domain.IUsersRepo: domain.IRepo
---@operator call: domain.IUsersRepo
local IUsersRepo = IRepo + {}

---@param user_name string
---@return table?
function IUsersRepo:getByName(user_name)
end

---@param osu_id number
---@return table?
function IUsersRepo:getByOsuId(osu_id)
end

return IUsersRepo
