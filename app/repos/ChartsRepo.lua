local IChartsRepo = require("domain.repos.IChartsRepo")
local Repo = require("app.repos.Repo")

---@class app.ChartsRepo: app.Repo, domain.IChartsRepo
---@operator call: app.ChartsRepo
local ChartsRepo = Repo + IChartsRepo

ChartsRepo.model_name = "charts"

return ChartsRepo
