local IRepo = require("domain.repos.IRepo")

---@class domain.ITracksRepo: domain.IRepo
---@operator call: domain.ITracksRepo
local ITracksRepo = IRepo + {}

return ITracksRepo
