local class = require("class")
local ChartNameGenerator = require("domain.ChartNameGenerator")
local ChartRepacker = require("domain.ChartRepacker")
local ChartAnoner = require("domain.ChartAnoner")
local ChartFormatter = require("domain.ChartFormatter")

---@class domain.Charts
---@operator call: domain.Charts
local Charts = class()

---@param chartsRepo domain.IChartsRepo
---@param contestsRepo domain.IContestsRepo
---@param filesRepo domain.IFilesRepo
---@param tracksRepo domain.ITracksRepo
---@param contestUsersRepo domain.IContestUsersRepo
---@param usersRepo domain.IUsersRepo
---@param oszReader domain.OszReader
---@param archiveFactory domain.IArchiveFactory
---@param contests domain.Contests
function Charts:new(chartsRepo, contestsRepo, filesRepo, tracksRepo, contestUsersRepo, usersRepo, oszReader, archiveFactory, contests)
	self.chartsRepo = chartsRepo
	self.contestsRepo = contestsRepo
	self.filesRepo = filesRepo
	self.tracksRepo = tracksRepo
	self.contestUsersRepo = contestUsersRepo
	self.usersRepo = usersRepo
	self.oszReader = oszReader
	self.archiveFactory = archiveFactory
	self.contests = contests
	self.nameGenerator = ChartNameGenerator()
	self.chartAnoner = ChartAnoner()
	self.chartFormatter = ChartFormatter()
	self.chartRepacker = ChartRepacker(self.archiveFactory, self.chartFormatter)
	self.chartAnonRepacker = ChartRepacker(self.archiveFactory, self.chartAnoner)
end

function Charts:canSubmitChart(user, contest, contest_user)
	return self.contests:canSubmitChart(user, contest, contest_user)
end

function Charts:canDelete(user, chart, contest)
	return user.id == contest.host_id or user.id == chart.charter_id and contest.is_submission_open
end

function Charts:canGetChartFile(user, contest_user, contest, chart)
	return user.id > 0 and self.contests:canGetVotes(user, contest_user, contest)
end

function Charts:canGetPackFile(user, contest)
	return user.id == contest.host_id
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

function Charts:getChartFile(user, chart_id, path_out)
	local chart = assert(self.chartsRepo:findById(chart_id))
	local contest = assert(self.contestsRepo:findById(chart.contest_id))
	local contest_user = self.contestUsersRepo:find({
		user_id = user.id,
		contest_id = contest.id
	})

	if not self:canGetChartFile(user, contest_user, contest, chart) then
		return
	end

	local file = assert(self.filesRepo:findById(chart.file_id))
	local track = assert(self.tracksRepo:findById(chart.track_id))

	local path = "storages/" .. file.hash
	local name = self.nameGenerator:generate(file.hash)

	if not contest.is_anon then
		return file.name, path
	end

	local paths = {{path, {track.meta, name}}}
	self.chartAnonRepacker:repack(paths, path_out)

	return ("%s - %s (%s).osz"):format(track.meta.Artist, track.meta.Title, name), path_out
end

function Charts:getPackFile(user, contest_id, path_out)
	local contest = assert(self.contestsRepo:findById(contest_id))
	if not self:canGetPackFile(user, contest) then
		return
	end
	local host = assert(self.usersRepo:findById(contest.host_id))

	local charts = self.chartsRepo:selectWithRels({contest_id = assert(contest_id)})
	local paths = {}
	for _, chart in ipairs(charts) do
		table.insert(paths, {
			"storages/" .. chart.file.hash,
			{
				meta = chart.track.meta,
				hashname = self.nameGenerator:generate(chart.file.hash),
				charter = chart.charter.name,
				host = host.name,
			}
		})
	end

	if not contest.is_anon then
		self.chartRepacker:repack(paths, path_out)
		return ("%s (%s charts).osz"):format(contest.name, #charts)
	end

	self.chartAnonRepacker:repack(paths, path_out)
	return ("%s (%s charts) anonymized.osz"):format(contest.name, #charts)
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
	local contest = assert(self.contestsRepo:findById(contest_id))
	local contest_user = self.contestUsersRepo:find({
		user_id = user.id,
		contest_id = contest.id
	})

	if not self:canSubmitChart(user, contest, contest_user) then
		return
	end

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
