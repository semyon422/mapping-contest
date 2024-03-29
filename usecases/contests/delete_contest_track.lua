local Usecase = require("http.Usecase")

---@class usecases.DeleteContestTrack: http.Usecase
---@operator call: usecases.DeleteContestTrack
local DeleteContestTrack = Usecase + {}

function DeleteContestTrack:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

function DeleteContestTrack:handle(params)
	self.domain.contestTracks:delete(params.contest_id, params.track_id)
	return "deleted", params
end

return DeleteContestTrack
