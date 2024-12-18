local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.DownloadPack: web.Usecase
---@operator call: usecases.DownloadPack
local DownloadPack = Usecase + {}

function DownloadPack:handle(params)
	local path_out = os.tmpname()
	local filename = self.domain.charts:getPackFile(params.session_user, params.contest_id, path_out)
	local f = assert(io.open(path_out, "rb"))
	params.content = f:read("*a")
	params.filename = filename
	f:close()
	assert(os.remove(path_out))
	return "ok"
end

return DownloadPack
