local filehash = require("util.filehash")
local osu_util = require("osu_util")
local types = require("lapis.validate.types")

local submit_track = {}

submit_track.policy_set = {{"contest_host"}}

submit_track.validate = types.partial({
	contest_id = types.db_id,
	file = types.shape({
		content = types.string,
		filename = types.string,
		name = types.string,
		["content-type"] = types.string,
	}),
})

function submit_track.handler(params, models)
	local _file = params.file

	local hash = filehash.sum(_file.content)

	local file = models:find({hash = hash})
	local track
	if not file then
		file = models.files:create({
			hash = hash,
			name = _file.filename,
			uploaded = true,
			size = #_file.content,
			created_at = os.time(),
		})
		file:write_file(_file.content)

		local osz, err = osu_util.parse_osz(file:get_path())
		if not osz then
			file:delete_file()
			file:delete()
			return {status = 400, err}
		end

		track = models.tracks:create({
			file_id = file.id,
			title = osz.Title,
			artist = osz.Artist,
			created_at = os.time(),
		})
	else
		track = models.tracks:find({file_id = file.id})
	end

	local contest_track = {
		contest_id = params.contest_id,
		track_id = track.id,
	}

	local found_contest_track = models.contest_tracks:find(contest_track)
	if found_contest_track then
		return
	end

	models.contest_tracks:create(contest_track)

	return "ok", params
end

return submit_track
