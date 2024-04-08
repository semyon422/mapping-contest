local class = require("class")
local ChartNameGenerator = require("domain.ChartNameGenerator")
local ChartRepacker = require("domain.ChartRepacker")
local ChartAnoner = require("domain.ChartAnoner")

---@class domain.Charts
---@operator call: domain.Charts
local Charts = class()

---@param chartsRepo domain.IChartsRepo
---@param contestsRepo domain.IContestsRepo
---@param filesRepo domain.IFilesRepo
---@param tracksRepo domain.ITracksRepo
---@param oszReader domain.OszReader
---@param archiveFactory domain.IArchiveFactory
function Charts:new(chartsRepo, contestsRepo, filesRepo, tracksRepo, oszReader, archiveFactory)
	self.chartsRepo = chartsRepo
	self.contestsRepo = contestsRepo
	self.filesRepo = filesRepo
	self.tracksRepo = tracksRepo
	self.oszReader = oszReader
	self.archiveFactory = archiveFactory
	self.nameGenerator = ChartNameGenerator()
	self.chartAnoner = ChartAnoner()
	self.chartRepacker = ChartRepacker(self.archiveFactory, self.chartAnoner)
end

function Charts:canDelete(user, chart, contest)
	return user.id == contest.host_id or user.id == chart.charter_id and contest.is_submission_open
end

function Charts:delete(user, chart_id)
	local chart = self.chartsRepo:findById(chart_id)
	if not chart then
		return
	end
	local contest = self.contestsRepo:findById(chart.contest_id)
	if not self:canDelete(user, chart, contest) then
		return
	end
	self.chartsRepo:deleteById(chart_id)
end

function Charts:getChart(user, chart_id)
	return self.chartsRepo:findById(chart_id)
end

function Charts:getChartRepacked(user, chart_id, path_out)
	local chart = self.chartsRepo:findById(chart_id)
	local file = self.filesRepo:findById(chart.file_id)
	local track = self.tracksRepo:findById(chart.track_id)

	local path = "storages/" .. file.hash
	local name = self.nameGenerator:generate(file.hash)

	local paths = {{path, {track.meta, name}}}
	self.chartRepacker:repack(paths, path_out)

	return ("%s - %s (%s).osz"):format(track.meta.Artist, track.meta.Title, name)
end

function Charts:getPack(user, contest_id, path_out)
	local contest = self.contestsRepo:findById(contest_id)
	local charts = self.chartsRepo:selectWithRels({contest_id = assert(contest_id)})
	local paths = {}
	for _, chart in ipairs(charts) do
		table.insert(paths, {
			"storages/" .. chart.file.hash,
			{chart.track.meta, self.nameGenerator:generate(chart.file.hash)}
		})
	end

	self.chartRepacker:repack(paths, path_out)

	return ("%s (%s charts).osz"):format(contest.name, #charts)
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
	local osz, err = self.oszReader:read(_file.path)
	if not osz then
		return nil, err
	end

	local track = self.tracksRepo:find({
		title = osz.Title,
		artist = osz.Artist,
	})
	if not track then
		return nil, err
	end

	local hash = _file.hash

	local file = self.filesRepo:findByHash(hash)
	if not file then
		file = self.filesRepo:create({
			hash = hash,
			name = _file.filename,
			uploaded = true,
			size = _file.size,
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
