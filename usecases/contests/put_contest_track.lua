local Usecase = require("usecases.Usecase")

local put_contest_track = Usecase()

put_contest_track:bindModel("contests", {id = "contest_id"})
put_contest_track:bindModel("tracks", {id = "track_id"})

put_contest_track:setHandler(function(params, models)
	models.contest_tracks:create({
		contest_id = params.contest_id,
		track_id = params.track_id,
	})

	return "deleted", params
end)

return put_contest_track
