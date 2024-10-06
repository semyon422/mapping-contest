local Usecase = require("web.usecase.Usecase")

---@class usecases.SubmitChart: web.Usecase
---@operator call: usecases.SubmitChart
local SubmitChart = Usecase + {}

function SubmitChart:handle(params)
	local file = params.file
	local chart = self.domain.charts:submit(params.session_user, file, params.contest_id)
	if not chart then
		assert(os.remove(file.path))
	end
	return "ok"
end

return SubmitChart
