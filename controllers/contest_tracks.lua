local Tracks = require("models.tracks")
local Files = require("models.files")
local Contest_tracks = require("models.contest_tracks")
local Filehash = require("util.filehash")
local types = require("lapis.validate.types")
local with_params = require("lapis.validate").with_params
local osu_util = require("osu_util")

local contest_tracks_c = {}

contest_tracks_c.POST = with_params({
	{"contest_id", types.db_id},
	{"file", types.shape({
		content = types.string,
		filename = types.string,
		name = types.string,
		["content-type"] = types.string,
	})},
}, function(self, params)
	local _file = params.file

	local hash = Filehash:sum_for_db_raw(_file.content)

	local file = Files:find({hash = hash})
	local track
	if not file then
		file = Files:create({
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

		track = Tracks:create({
			file_id = file.id,
			title = osz.Title,
			artist = osz.Artist,
			created_at = os.time(),
		})
	else
		track = Tracks:find({file_id = file.id})
	end

	local contest_track = {
		contest_id = params.contest_id,
		track_id = track.id,
	}

	local found_contest_track = Contest_tracks:find(contest_track)
	if found_contest_track then
		return
	end

	Contest_tracks:create(contest_track)

	return {status = 201}
end)

return contest_tracks_c
