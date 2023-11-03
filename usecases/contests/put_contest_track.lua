local put_contest_track = {}

put_contest_track.models = {
	contest = {"contests", {id = "contest_id"}},
	track = {"tracks", {id = "track_id"}},
}

function put_contest_track.handler(params, models)
	models.contest_tracks:create({
		contest_id = params.contest_id,
		track_id = params.track_id,
	})

	return "deleted", params
end

return put_contest_track
