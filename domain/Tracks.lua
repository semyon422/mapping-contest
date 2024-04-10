local class = require("class")

---@class domain.Tracks
---@operator call: domain.Tracks
local Tracks = class()

---@param filesRepo domain.IFilesRepo
---@param tracksRepo domain.ITracksRepo
---@param contestsRepo domain.IContestsRepo
---@param contestUsersRepo domain.IContestUsersRepo
---@param oszReader domain.OszReader
---@param contests domain.Contests
function Tracks:new(filesRepo, tracksRepo, contestsRepo, contestUsersRepo, oszReader, contests)
	self.filesRepo = filesRepo
	self.tracksRepo = tracksRepo
	self.contestsRepo = contestsRepo
	self.contestUsersRepo = contestUsersRepo
	self.oszReader = oszReader
	self.contests = contests
end

function Tracks:canDeleteTrack(user, contest, track)
	return self.contests:canUpdateContest(user, contest)
end

function Tracks:canGetTrackFile(user, contest_user, contest, track)
	return self.contests:canGetTracks(user, contest_user, contest)
end

function Tracks:canSubmitTrack(user, contest)
	return self.contests:canUpdateContest(user, contest)
end

function Tracks:delete(user, track_id)
	local track = assert(self.tracksRepo:findById(track_id))
	local contest = assert(self.contestsRepo:findById(track.contest_id))
	if not self:canDeleteTrack(user, contest, track) then
		return
	end
	self.tracksRepo:deleteById(track_id)
end

function Tracks:getTrackFile(user, track_id)
	local track = assert(self.tracksRepo:findById(track_id))
	local contest = assert(self.contestsRepo:findById(track.contest_id))
	local contest_user = self.contestUsersRepo:find({
		user_id = user.id,
		contest_id = contest.id
	})

	if not self:canGetTrackFile(user, contest_user, contest, track) then
		return
	end

	local file = assert(self.filesRepo:findById(track.file_id))
	local path = "storages/" .. file.hash
	return file.name, path
end

-- SubmitTrack.validate = {
-- 	contest_id = "integer",
-- 	file = {
-- 		tmpname = "string",
-- 		filename = "string",
-- 		hash = "string",
-- 		size = "integer",
-- 	},
-- }

function Tracks:create(user, _file, contest_id)
	local contest = assert(self.contestsRepo:findById(contest_id))
	if not self:canSubmitTrack(user, contest) then
		return
	end

	local osz, err = self.oszReader:read(_file.path)
	if not osz then
		return nil, err
	end

	local hash = _file.hash

	local file = self.filesRepo:find({hash = hash})
	if not file then
		file = self.filesRepo:create({
			hash = hash,
			name = _file.filename,
			uploaded = true,
			size = _file.size,
			created_at = os.time(),
		})
	end

	local track = self.tracksRepo:find({file_id = file.id})
	if not track then
		track = self.tracksRepo:create({
			file_id = file.id,
			contest_id = contest_id,
			title = osz.Title,
			artist = osz.Artist,
			meta = osz,
			created_at = os.time(),
		})
	end

	return track
end

return Tracks
