local class = require("class")

---@class domain.Tracks
---@operator call: domain.Tracks
local Tracks = class()

---@param filesRepo domain.IFilesRepo
---@param tracksRepo domain.ITracksRepo
---@param oszReader domain.OszReader
function Tracks:new(filesRepo, tracksRepo, oszReader)
	self.filesRepo = filesRepo
	self.tracksRepo = tracksRepo
	self.oszReader = oszReader
end

function Tracks:delete(user, track_id)
	self.tracksRepo:deleteById(track_id)
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
