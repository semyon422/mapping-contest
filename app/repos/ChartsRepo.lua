local IChartsRepo = require("domain.repos.IChartsRepo")
local Repo = require("app.repos.Repo")
local relations = require("rdb.relations")

---@class app.ChartsRepo: app.Repo, domain.IChartsRepo
---@operator call: app.ChartsRepo
local ChartsRepo = Repo + IChartsRepo

ChartsRepo.model_name = "charts"

---@param conds table?
---@return table
function ChartsRepo:selectWithRels(conds)
	local charts = self:select(conds)
	relations.preload(charts, {"file", "track", "charter"})
	return charts
end

return ChartsRepo
