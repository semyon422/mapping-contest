local IRepo = require("domain.repos.IRepo")

---@class domain.IChartsRepo: domain.IRepo
---@operator call: domain.IChartsRepo
local IChartsRepo = IRepo + {}

return IChartsRepo
