local IContestsRepo = require("domain.repos.IContestsRepo")
local Repo = require("app.repos.Repo")

---@class app.ContestsRepo: app.Repo, domain.IContestsRepo
---@operator call: app.ContestsRepo
local ContestsRepo = Repo + IContestsRepo

ContestsRepo.model_name = "contests"

return ContestsRepo
