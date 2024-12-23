local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.DownloadChart: web.Usecase
---@operator call: usecases.DownloadChart
local DownloadChart = Usecase + {}

function DownloadChart:handle(params)
	local path_out = os.tmpname()
	local filename, read_path = self.domain.charts:getChartFile(
		params.session_user, params.chart_id, path_out
	)
	local f = assert(io.open(read_path, "rb"))
	params.content = f:read("*a")
	params.filename = filename
	f:close()
	assert(os.remove(path_out))
	return "ok"
end

return DownloadChart
