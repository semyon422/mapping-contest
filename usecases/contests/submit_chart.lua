local osu_util = require("osu_util")
local File = require("domain.File")
local Usecase = require("http.Usecase")

---@class usecases.SubmitChart: http.Usecase
---@operator call: usecases.SubmitChart
local SubmitChart = Usecase + {}

function SubmitChart:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:canSubmitChart(params.session_user, params.contest)
end

SubmitChart.models = {
	contest = {"contests", {id = "contest_id"}, {"contest_users"}},
}

SubmitChart.validate = {
	contest_id = "integer",
	file = {
		tmpname = "string",
		filename = "string",
		hash = "string",
		size = "integer",
	},
}

function SubmitChart:handle(params)
	local models = self.models
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

	params.chart = models.charts:create({
		track_id = track.id,
		charter_id = params.session.user_id,
		contest_id = params.contest_id,
		file_id = file.id,
		name = osz.Version,
		notes = osz.HitObjects,
		submitted_at = os.time(),
	}, true)

	return "ok", params
end

return SubmitChart
