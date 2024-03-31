local ISectionsRepo = require("domain.repos.ISectionsRepo")

---@class app.SectionsRepo: domain.ISectionsRepo
---@operator call: app.SectionsRepo
local SectionsRepo = ISectionsRepo + {}

---@param appDatabase app.AppDatabase
function SectionsRepo:new(appDatabase)
	self.models = appDatabase.models
end

---@param section_id number
---@return table?
function SectionsRepo:getById(section_id)
	return self.models.sections:find({id = assert(section_id)})
end

---@param section_id number
function SectionsRepo:deleteById(section_id)
	return self.models.sections:delete({id = assert(section_id)})
end

---@param section table
function SectionsRepo:create(section)
	return self.models.sections:create(section)
end

---@param section table
function SectionsRepo:update(section)
	return self.models.sections:update(section, {id = assert(section.id)})
end

return SectionsRepo
