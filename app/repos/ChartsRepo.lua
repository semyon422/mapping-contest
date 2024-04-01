local IChartsRepo = require("domain.repos.IChartsRepo")

---@class app.ChartsRepo: domain.IChartsRepo
---@operator call: app.ChartsRepo
local ChartsRepo = IChartsRepo + {}

---@param appDatabase app.AppDatabase
function ChartsRepo:new(appDatabase)
	self.models = appDatabase.models
end

---@param chart_id number
---@return table?
function ChartsRepo:getById(chart_id)
	return self.models.charts:find({id = assert(chart_id)})
end

---@param chart_id number
function ChartsRepo:deleteById(chart_id)
	return self.models.charts:delete({id = assert(chart_id)})
end

---@return table?
function ChartsRepo:getAll()
	return self.models.charts:select()
end

---@param chart table
function ChartsRepo:update(chart)
	return self.models.charts:update(chart, {id = assert(chart.id)})
end

---@param chart table
function ChartsRepo:create(chart)
	return self.models.charts:create(chart)
end

return ChartsRepo
