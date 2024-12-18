local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.DeleteTrack: web.Usecase
---@operator call: usecases.DeleteTrack
local DeleteTrack = Usecase + {}

function DeleteTrack:handle(params)
	self.domain.tracks:delete(params.session_user, params.track_id)
	return "deleted"
end

return DeleteTrack
