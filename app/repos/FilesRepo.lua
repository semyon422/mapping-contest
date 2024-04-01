local IFilesRepo = require("domain.repos.IFilesRepo")
local Repo = require("app.repos.Repo")

---@class app.FilesRepo: app.Repo, domain.IFilesRepo
---@operator call: app.FilesRepo
local FilesRepo = Repo + IFilesRepo

FilesRepo.model_name = "files"

---@param hash string
function FilesRepo:findByHash(hash)
	return self.model:find({hash = assert(hash)})
end

return FilesRepo
