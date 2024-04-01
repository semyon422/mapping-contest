local ITracksRepo = require("domain.repos.ITracksRepo")
local Repo = require("app.repos.Repo")

---@class app.TracksRepo: app.Repo, domain.ITracksRepo
---@operator call: app.TracksRepo
local TracksRepo = Repo + ITracksRepo

TracksRepo.model_name = "tracks"

return TracksRepo
