local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.DeleteChart: web.Usecase
---@operator call: usecases.DeleteChart
local DeleteChart = Usecase + {}

function DeleteChart:handle(params)
	self.domain.charts:delete(params.session_user, params.chart_id)
	return "deleted"
end

return DeleteChart
