local Usecase = require("http.Usecase")

---@class usecases.SubmitTrack: http.Usecase
---@operator call: usecases.SubmitTrack
local SubmitTrack = Usecase + {}

function SubmitTrack:handle(params)
	self.domain.contestTracks:create(params)
	return "ok"
end

return SubmitTrack
