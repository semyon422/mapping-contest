local IRepo = require("domain.repos.IRepo")

---@class domain.IVotesRepo: domain.IRepo
---@operator call: domain.IVotesRepo
local IVotesRepo = IRepo + {}

return IVotesRepo
