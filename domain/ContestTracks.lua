local IRepo = require("domain.repos.IRepo")

---@class domain.IContestTracksRepo: domain.IRepo
---@operator call: domain.IContestTracksRepo
local IContestTracksRepo = IRepo + {}

return IContestTracksRepo
