local Usecase = require("http.Usecase")

---@class usecases.DeleteContestTrack: http.Usecase
---@operator call: usecases.DeleteContestTrack
local DeleteContestTrack = Usecase + {}

function DeleteContestTrack:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

DeleteContestTrack.models = {
	contest = {"contests", {id = "contest_id"}},
	contest_track = {"contest_tracks", {"contest_id", "track_id"}},
}

function DeleteContestTrack:handle(params)
	params.contest_track:delete()

	-- local count = models.contest_tracks:count("track_id = ?", params.track_id)
	-- if count ~= 0 then
	-- 	return
	-- end

	-- ctx.track:delete()

	return "deleted", params
end

return DeleteContestTrack
