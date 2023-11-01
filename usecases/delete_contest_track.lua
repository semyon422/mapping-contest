local Usecase = require("usecases.Usecase")

local delete_contest_track = Usecase()

delete_contest_track:setPolicySet({{"contest_host"}})

delete_contest_track:bindModel("contest_tracks", {"contest_id", "track_id"})

delete_contest_track:setHandler(function(params, models)
	params.contest_track:delete()

	-- local count = models.contest_tracks:count("track_id = ?", params.track_id)
	-- if count ~= 0 then
	-- 	return
	-- end

	-- ctx.track:delete()

	return "deleted", params
end)

return delete_contest_track
