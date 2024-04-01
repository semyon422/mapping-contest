local ISectionsRepo = require("domain.repos.ISectionsRepo")
local Repo = require("app.repos.Repo")

---@class app.SectionsRepo: app.Repo, domain.ISectionsRepo
---@operator call: app.SectionsRepo
local SectionsRepo = Repo + ISectionsRepo

SectionsRepo.model_name = "sections"

return SectionsRepo
