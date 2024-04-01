local IContestUsersRepo = require("domain.repos.IContestUsersRepo")
local Repo = require("app.repos.Repo")

---@class app.ContestUsersRepo: app.Repo, domain.IContestUsersRepo
---@operator call: app.ContestUsersRepo
local ContestUsersRepo = Repo + IContestUsersRepo

ContestUsersRepo.model_name = "contest_users"

return ContestUsersRepo
