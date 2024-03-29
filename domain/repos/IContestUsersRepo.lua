local IRepo = require("domain.repos.IRepo")

---@class domain.IContestUsersRepo: domain.IRepo
---@operator call: domain.IContestUsersRepo
local IContestUsersRepo = IRepo + {}

return IContestUsersRepo
