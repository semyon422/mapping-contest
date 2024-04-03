local Usecase = require("http.Usecase")

---@class usecases.DownloadChart: http.Usecase
---@operator call: usecases.DownloadChart
local DownloadChart = Usecase + {}

function DownloadChart:handle(params)
	local path_out = os.tmpname()
	local filename = self.domain.charts:getChartRepacked(params.session_user, params.chart_id, path_out)
	local f = assert(io.open(path_out, "rb"))
	params.content = f:read("*a")
	params.filename = filename
	f:close()
	assert(os.remove(path_out))
	return "ok"
end

return DownloadChart
