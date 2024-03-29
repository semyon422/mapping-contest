local osu_util = require("osu_util")
local File = require("domain.File")
local Usecase = require("http.Usecase")

---@class usecases.SubmitChart: http.Usecase
---@operator call: usecases.SubmitChart
local SubmitChart = Usecase + {}

function SubmitChart:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:canSubmitChart(params.session_user, params.contest)
end

function SubmitChart:handle(params)
	self.domain.charts:submit(params)

	return "ok", params
end

return SubmitChart
