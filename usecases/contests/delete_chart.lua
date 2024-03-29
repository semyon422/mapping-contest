local Usecase = require("http.Usecase")

---@class usecases.DeleteChart: http.Usecase
---@operator call: usecases.DeleteChart
local DeleteChart = Usecase + {}

function DeleteChart:authorize(params)
	if not params.session_user then return end
	return self.domain.charts:canDelete(params.session_user, params.chart)
end

function DeleteChart:handle(params)
	self.domain.charts:delete(params.session_user, params.chart_id)
	return "deleted", params
end

return DeleteChart
