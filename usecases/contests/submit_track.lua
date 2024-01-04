local osu_util = require("osu_util")
local types = require("lapis.validate.types")
local File = require("domain.File")

local submit_track = {}

submit_track.access = {{"contest_host"}}

submit_track.models = {contest = {"contests", {id = "contest_id"}}}

submit_track.validate = types.partial({
	contest_id = types.db_id,
	file = types.shape({
		tmpname = types.string,
		filename = types.string,
		hash = types.string,
		size = types.integer,
	}),
})

function submit_track.handle(params, models)
	local _file = params.file

	local osz, err = osu_util.parse_osz(_file.tmpname)
	if not osz then
		assert(os.remove(_file.tmpname))
		return "validation", {errors = {err}}
	end

	local hash = _file.hash
	local d_file = File(hash)
	assert(os.rename(_file.tmpname, d_file:get_path()))

	local file = models.files:find({hash = hash})
	local track
	if not file then
		file = models.files:create({
			hash = hash,
			name = _file.filename,
			uploaded = true,
			size = _file.size,
			created_at = os.time(),
		})
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
		return "ok", params
	end

	models.contest_tracks:create(contest_track)

	return "ok", params
end

return submit_track
