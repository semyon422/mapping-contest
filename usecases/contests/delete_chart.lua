local Usecase = require("http.Usecase")

---@class usecases.DeleteChart: http.Usecase
---@operator call: usecases.DeleteChart
local DeleteChart = Usecase + {}

function DeleteChart:handle(params)
	self.domain.charts:delete(params.session_user, params.chart_id)
	return "deleted"
end

return DeleteChart
