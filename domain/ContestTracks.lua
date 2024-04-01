local class = require("class")
local osu_util = require("osu_util")
local File = require("domain.File")

---@class domain.ContestTracks
---@operator call: domain.ContestTracks
local ContestTracks = class()

---@param contestTracksRepo domain.IContestTracksRepo
---@param filesRepo domain.IFilesRepo
---@param tracksRepo domain.ITracksRepo
function ContestTracks:new(contestTracksRepo, filesRepo, tracksRepo)
	self.contestTracksRepo = contestTracksRepo
	self.filesRepo = filesRepo
	self.tracksRepo = tracksRepo
end

function ContestTracks:delete(contest_id, track_id)
	self.contestTracksRepo:delete({
		contest_id = contest_id,
		track_id = track_id,
	})
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

function ContestTracks:create(_file, contest_id)
	local osz, err = osu_util.parse_osz(_file.tmpname)
	if not osz then
		assert(os.remove(_file.tmpname))
		return nil, err
	end

	local hash = _file.hash
	local d_file = File(hash)
	assert(os.rename(_file.tmpname, d_file:get_path()))

	local file = self.filesRepo:find({hash = hash})
	local track
	if not file then
		file = self.filesRepo:create({
			hash = hash,
			name = _file.filename,
			uploaded = true,
			size = _file.size,
			created_at = os.time(),
		})
		track = self.tracksRepo:create({
			file_id = file.id,
			title = osz.Title,
			artist = osz.Artist,
			created_at = os.time(),
		})
	else
		track = self.tracksRepo:find({file_id = file.id})
	end

	local contest_track = {
		contest_id = contest_id,
		track_id = track.id,
	}

	local found_contest_track = self.contestTracksRepo:find(contest_track)
	if found_contest_track then
		return found_contest_track
	end

	return self.contestTracksRepo:create(contest_track)
end

return ContestTracks
