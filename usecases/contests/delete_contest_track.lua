local delete_contest_track = {}

delete_contest_track.policy_set = {{"contest_host"}}

delete_contest_track.models = {
	contest = {"contests", {id = "contest_id"}},
	contest_track = {"contest_tracks", {"contest_id", "track_id"}},
}

function delete_contest_track.handler(params, models)
	params.contest_track:delete()

	-- local count = models.contest_tracks:count("track_id = ?", params.track_id)
	-- if count ~= 0 then
	-- 	return
	-- end

	-- ctx.track:delete()

	return "deleted", params
end

return delete_contest_track
