local Usecase = require("http.Usecase")

---@class usecases.SubmitChart: http.Usecase
---@operator call: usecases.SubmitChart
local SubmitChart = Usecase + {}

function SubmitChart:handle(params)
	self.domain.charts:submit(params)
	return "ok"
end

return SubmitChart
