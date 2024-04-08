local IRepo = require("domain.repos.IRepo")

---@class domain.IChartsRepo: domain.IRepo
---@operator call: domain.IChartsRepo
local IChartsRepo = IRepo + {}

---@param conds table?
---@return table
function IChartsRepo:selectWithRels(conds)
	return {}
end

return IChartsRepo
