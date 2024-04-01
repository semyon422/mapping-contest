local Usecase = require("http.Usecase")

---@class usecases.SubmitChart: http.Usecase
---@operator call: usecases.SubmitChart
local SubmitChart = Usecase + {}

function SubmitChart:handle(params)
	self.domain.charts:submit(params.session_user, params.file, params.contest_id)
	return "ok"
end

return SubmitChart
