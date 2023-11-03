local Sections = require("domain.Sections")
local Filehash = require("util.filehash")
local osu_util = require("osu_util")

local submit_chart = {}

submit_chart.policy_set = {{"role_verified"}}

function submit_chart.handler(params, models)
	local _file = params.file

	local hash = Filehash:sum_for_db_raw(_file.content)

	local file = models.files:select({hash = hash})[1]
	if not file then
		file = models.files:insert({
			hash = hash,
			name = _file.filename,
			uploaded = true,
			size = #_file.content,
			created_at = os.time(),
		})
		file:write_file(_file.content)
	end

	local osz, err = osu_util.parse_osz(file:get_path())
	if not osz then
		file:delete_file()
		file:delete()
		return {status = 400, err}
	end

	local track = models.tracks:select({
		title = osz.Title,
		artist = osz.Artist,
	})[1]
	if not track then
		-- file:delete_file()
		-- file:delete()
		-- return {status = 400, "track not found"}
		track = models.tracks:insert({
			file_id = file.id,
			title = osz.Title,
			artist = osz.Artist,
			created_at = os.time(),
		})
	end

	local contest = models.contests:select(params.contest_id)[1]
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
