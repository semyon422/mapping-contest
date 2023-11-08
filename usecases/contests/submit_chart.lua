local Sections = require("domain.Sections")
local filehash = require("util.filehash")
local osu_util = require("osu_util")
local types = require("lapis.validate.types")
local File = require("domain.File")

local submit_chart = {}

submit_chart.policy_set = {{"role_verified"}}

submit_chart.validate = types.partial({
	contest_id = types.db_id,
	file = types.shape({
		content = types.string,
		filename = types.string,
		name = types.string,
		["content-type"] = types.string,
	}),
})

function submit_chart.handler(params, models)
	local _file = params.file

	local hash = filehash.sum(_file.content)

	local file = models.files:find({hash = hash})
	local d_file = File(hash)
	if not file then
		file = models.files:create({
			hash = hash,
			name = _file.filename,
			uploaded = true,
			size = #_file.content,
			created_at = os.time(),
		})
		d_file:write(_file.content)
	end

	local osz, err = osu_util.parse_osz(file:get_path())
	if not osz then
		d_file:delete()
		file:delete()
		return {status = 400, err}
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

	local contest = models.contests:find(params.contest_id)
	local section = Sections:get_section(os.time() - contest.started_at, osz.HitObjects)

	params.chart = models.charts:create({
		track_id = track.id,
		charter_id = params.session.user_id,
		contest_id = params.contest_id,
		file_id = file.id,
		section = Sections:for_db(section),
		name = osz.Version,
		submitted_at = os.time(),
	})

	return "created", params
end

return submit_chart
