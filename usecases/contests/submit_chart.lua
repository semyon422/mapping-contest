local Sections = require("domain.Sections")
local osu_util = require("osu_util")
local types = require("lapis.validate.types")
local File = require("domain.File")

local submit_chart = {}

submit_chart.policy_set = {{"role_verified"}}

submit_chart.validate = types.partial({
	contest_id = types.db_id,
	file = types.shape({
		tmpname = types.string,
		filename = types.string,
		hash = types.string,
		size = types.integer,
	}),
})

function submit_chart.handler(params, models)
	local _file = params.file

	local osz, err = osu_util.parse_osz(_file.tmpname)
	if not osz then
		assert(os.remove(_file.tmpname))
		return {status = 400, err}
	end

	local hash = _file.hash
	local d_file = File(hash)
	assert(os.rename(_file.tmpname, d_file:get_path()))

	local file = models.files:find({hash = hash})
	if not file then
		file = models.files:create({
			hash = hash,
			name = _file.filename,
			uploaded = true,
			size = _file.size,
			created_at = os.time(),
		})
	end

	local track = models.tracks:find({
		title = osz.Title,
		artist = osz.Artist,
	})
	if not track then
		track = models.tracks:create({
			file_id = file.id,
			title = osz.Title,
			artist = osz.Artist,
			created_at = os.time(),
		})
	end

	local contest = models.contests:find({id = params.contest_id})
	local section = Sections:get_section(os.time() - contest.started_at, osz.HitObjects)

	params.chart = models.charts:create({
		track_id = track.id,
		charter_id = params.session.user_id,
		contest_id = params.contest_id,
		file_id = file.id,
		section = section,
		name = osz.Version,
		submitted_at = os.time(),
	})

	return "created", params
end

return submit_chart
