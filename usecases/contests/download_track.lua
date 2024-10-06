local Usecase = require("web.usecase.Usecase")

---@class usecases.DownloadTrack: web.Usecase
---@operator call: usecases.DownloadTrack
local DownloadTrack = Usecase + {}

function DownloadTrack:handle(params)
	local filename, path = self.domain.tracks:getTrackFile(params.session_user, params.track_id)
	local f = assert(io.open(path, "rb"))
	params.content = f:read("*a")
	params.filename = filename
	f:close()
	return "ok"
end

return DownloadTrack
