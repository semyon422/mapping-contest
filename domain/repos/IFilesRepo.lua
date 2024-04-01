local IRepo = require("domain.repos.IRepo")

---@class domain.IFilesRepo: domain.IRepo
---@operator call: domain.IFilesRepo
local IFilesRepo = IRepo + {}

---@param hash string
function IFilesRepo:findByHash(hash)
end

return IFilesRepo
