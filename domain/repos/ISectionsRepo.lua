local IRepo = require("domain.repos.IRepo")

---@class domain.ISectionsRepo: domain.IRepo
---@operator call: domain.ISectionsRepo
local ISectionsRepo = IRepo + {}

return ISectionsRepo
