local Usecase = require("http.Usecase")

---@class usecases.SubmitTrack: http.Usecase
---@operator call: usecases.SubmitTrack
local SubmitTrack = Usecase + {}

function SubmitTrack:handle(params)
	self.domain.tracks:create(params.session_user, params.file, params.contest_id)
	return "ok"
end

return SubmitTrack
