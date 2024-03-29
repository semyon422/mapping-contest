local class = require("class")

---@class domain.IRepo
---@operator call: domain.IRepo
local IRepo = class()

---@param obj_id number
---@return table?
function IRepo:getById(obj_id)
	return {}
end

---@param conds table
---@return table?
function IRepo:get(conds)
	return {}
end

---@param conds table
---@return table
function IRepo:select(conds)
	return {}
end

---@return table
function IRepo:getAll()
	return {}
end

---@param obj table
---@return table
function IRepo:create(obj)
	return {}
end

---@param conds table
---@return table
function IRepo:delete(conds)
	return {}
end

---@param obj_id number
function IRepo:deleteById(obj_id)
end

---@param obj table
function IRepo:update(obj)
end

return IRepo
