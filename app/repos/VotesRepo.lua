local IVotesRepo = require("domain.repos.IVotesRepo")
local Repo = require("app.repos.Repo")

---@class app.VotesRepo: app.Repo, domain.IVotesRepo
---@operator call: app.VotesRepo
local VotesRepo = Repo + IVotesRepo

VotesRepo.model_name = "user_contest_chart_votes"

return VotesRepo
