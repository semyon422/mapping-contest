local IRepo = require("domain.repos.IRepo")

---@class domain.IChartCommentsRepo: domain.IRepo
---@operator call: domain.IChartCommentsRepo
local IChartCommentsRepo = IRepo + {}

return IChartCommentsRepo
