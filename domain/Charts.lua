local class = require("class")
local File = require("domain.File")
local osu_util = require("osu_util")

---@class domain.Charts
---@operator call: domain.Charts
local Charts = class()

---@param chartsRepo domain.IChartsRepo
---@param contestsRepo domain.IContestsRepo
---@param filesRepo domain.IFilesRepo
---@param tracksRepo domain.ITracksRepo
function Charts:new(chartsRepo, contestsRepo, filesRepo, tracksRepo)
	self.chartsRepo = chartsRepo
	self.contestsRepo = contestsRepo
	self.filesRepo = filesRepo
	self.tracksRepo = tracksRepo
end

function Charts:canDelete(user, chart, contest)
	return user.id == contest.host_id or user.id == chart.charter_id and contest.is_submission_open
end

function Charts:delete(user, chart_id)
	local chart = self.chartsRepo:getById(chart_id)
	if not chart then
		return
	end
	local contest = self.contestsRepo:getById(chart.contest_id)
	if not self:canDelete(user, chart, contest) then
		return
	end
	self.chartsRepo:deleteById(chart_id)
end


-- SubmitChart.validate = {
-- 	contest_id = "integer",
-- 	file = {
-- 		tmpname = "string",
-- 		filename = "string",
-- 		hash = "string",
-- 		size = "integer",
-- 	},
-- }

function Charts:submit(user, _file, contest_id)
	local osz, err = osu_util.parse_osz(_file.tmpname)
	if not osz then
		assert(os.remove(_file.tmpname))
		return nil, err
	end

	local hash = _file.hash
	local d_file = File(hash)
	assert(os.rename(_file.tmpname, d_file:get_path()))

	local file = self.filesRepo:getByHash(hash)
	if not file then
		file = self.filesRepo:create({
			hash = hash,
			name = _file.filename,
			uploaded = true,
			size = _file.size,
			created_at = os.time(),
		})
	end

	local track = self.tracksRepo:get({
		title = osz.Title,
		artist = osz.Artist,
	})
	if not track then
		track = self.tracksRepo:create({
			file_id = file.id,
			title = osz.Title,
			artist = osz.Artist,
			created_at = os.time(),
		})
	end

	local chart = self.chartsRepo:create({
		track_id = track.id,
		charter_id = user.id,
		contest_id = contest_id,
		file_id = file.id,
		name = osz.Version,
		notes = osz.HitObjects,
		submitted_at = os.time(),
	})

	return chart
end

return Charts
