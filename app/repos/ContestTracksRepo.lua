local IContestTracksRepo = require("domain.repos.IContestTracksRepo")
local Repo = require("app.repos.Repo")

---@class app.ContestTracksRepo: app.Repo, domain.IContestTracksRepo
---@operator call: app.ContestTracksRepo
local ContestTracksRepo = Repo + IContestTracksRepo

ContestTracksRepo.model_name = "contest_tracks"

return ContestTracksRepo
