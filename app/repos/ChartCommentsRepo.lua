local IChartCommentsRepo = require("domain.repos.IChartCommentsRepo")
local Repo = require("app.repos.Repo")

---@class app.ChartCommentsRepo: app.Repo, domain.IChartCommentsRepo
---@operator call: app.ChartCommentsRepo
local ChartCommentsRepo = Repo + IChartCommentsRepo

ChartCommentsRepo.model_name = "chart_comments"

return ChartCommentsRepo
