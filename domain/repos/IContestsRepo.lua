local IRepo = require("domain.repos.IRepo")

---@class domain.IContestsRepo: domain.IRepo
---@operator call: domain.IContestsRepo
local IContestsRepo = IRepo + {}

return IContestsRepo
