local IFilesRepo = require("domain.repos.IFilesRepo")

---@class app.FilesRepo: domain.IFilesRepo
---@operator call: app.FilesRepo
local FilesRepo = IFilesRepo + {}

---@param appDatabase app.AppDatabase
function FilesRepo:new(appDatabase)
	self.models = appDatabase.models
end

---@param file_id number
---@return table?
function FilesRepo:getById(file_id)
	return self.models.files:find({id = assert(file_id)})
end

---@param hash string
function FilesRepo:getByHash(hash)
	return self.models.files:find({hash = assert(hash)})
end

---@param file_id number
function FilesRepo:deleteById(file_id)
	return self.models.files:delete({id = assert(file_id)})
end

---@return table?
function FilesRepo:getAll()
	return self.models.files:select()
end

---@param file table
function FilesRepo:update(file)
	return self.models.files:update(file, {id = assert(file.id)})
end

---@param file table
function FilesRepo:create(file)
	return self.models.files:create(file)
end

return FilesRepo
