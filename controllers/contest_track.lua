local Contest_tracks = require("models.contest_tracks")

local contest_track_c = {}

function contest_track_c.PUT(self)
	local params = self.params

	local contest_track = Contest_tracks:create({
		contest_id = params.contest_id,
		track_id = params.track_id,
	})

	return {status = 201, redirect_to = self:url_for(contest_track)}
end

function contest_track_c.DELETE(self)
	local ctx = self.ctx
	local params = self.params

	ctx.contest_track:delete()

	local count = Contest_tracks:count("track_id = ?", params.track_id)
	if count ~= 0 then
		return
	end

	ctx.track:delete()
end

return contest_track_c
