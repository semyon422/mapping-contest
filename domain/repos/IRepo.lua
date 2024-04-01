local class = require("class")

---@class domain.IRepo
---@operator call: domain.IRepo
local IRepo = class()
class.to_interface(IRepo)

---@param obj_id number
---@return table?
function IRepo:findById(obj_id)
	return {}
end

---@param obj table
---@return table
function IRepo:updateById(obj)
	return {}
end

---@param obj_id number
function IRepo:deleteById(obj_id)
end

-- Model methods

---@param conds table?
---@return table
function IRepo:select(conds)
	return {}
end

---@param conds table
---@return table?
function IRepo:find(conds)
	return {}
end

---@param conds table?
---@return number
function IRepo:count(conds)
	return 0
end

---@param values_array table
---@return table
function IRepo:insert(values_array)
	return {}
end

---@param values table
---@return table
function IRepo:create(values)
	return {}
end

---@param values table
---@param conds table?
---@return table
function IRepo:update(values, conds)
	return {}
end

---@param conds table?
---@return table
function IRepo:delete(conds)
	return {}
end

return IRepo
