local Usecase = require("http.Usecase")

---@class usecases.DeleteChart: http.Usecase
---@operator call: usecases.DeleteChart
local DeleteChart = Usecase + {}

function DeleteChart:authorize(params)
	if not params.session_user then return end
	return self.domain.charts:canDelete(params.session_user, params.chart)
end

DeleteChart.models = {
	contest = {"contests", {id = "contest_id"}},
	chart = {"charts", {id = "chart_id"}, {"contest"}},  -- TODO: refactor this, contest loads twice
}

function DeleteChart:handle(params)
	params.chart:delete()
	return "deleted", params
end

return DeleteChart
