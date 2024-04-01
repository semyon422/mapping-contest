local IRepo = require("domain.repos.IRepo")

---@class app.Repo: domain.IRepo
---@operator call: app.Repo
---@field model rdb.Model
local Repo = IRepo + {}

Repo.model_name = nil

---@param appDatabase app.AppDatabase
function Repo:new(appDatabase)
	self.models = appDatabase.models
	local model_name = self.model_name
	assert(model_name, "missing model_name")
	self.model = self.models[model_name]
end

---@param obj_id number
---@return table?
function Repo:findById(obj_id)
	return self.model:find({id = assert(obj_id)})
end

---@param obj_id number
function Repo:deleteById(obj_id)
	return self.model:delete({id = assert(obj_id)})
end

-- Model methods

---@param conds table?
---@return table
function Repo:select(conds)
	return self.model:select(conds)
end

---@param conds table
---@return table?
function Repo:find(conds)
	return self.model:find(conds)
end

---@param conds table?
---@return number
function Repo:count(conds)
	return self.model:count(conds)
end

---@param objs table
---@return table
function Repo:insert(objs)
	return self.model:insert(objs)
end

---@param obj table
---@return table
function Repo:create(obj)
	return self.model:create(obj)
end

---@param obj table
---@return table
function Repo:update(obj)
	return self.model:update(obj, {id = assert(obj.id)})
end

---@param conds table?
---@return table
function Repo:delete(conds)
	return self.model:delete(conds)
end

return Repo
