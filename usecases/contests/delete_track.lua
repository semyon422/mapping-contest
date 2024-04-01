local Usecase = require("http.Usecase")

---@class usecases.DeleteTrack: http.Usecase
---@operator call: usecases.DeleteTrack
local DeleteTrack = Usecase + {}

function DeleteTrack:handle(params)
	self.domain.tracks:delete(params.session_user, params.track_id)
	return "deleted"
end

return DeleteTrack
