local Usecase = require("http.Usecase")

---@class usecases.DeleteContestTrack: http.Usecase
---@operator call: usecases.DeleteContestTrack
local DeleteContestTrack = Usecase + {}

function DeleteContestTrack:handle(params)
	self.domain.contestTracks:delete(params.contest_id, params.track_id)
	return "deleted"
end

return DeleteContestTrack
