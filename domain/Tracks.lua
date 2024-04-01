local class = require("class")
local osu_util = require("osu_util")
local File = require("domain.File")

---@class domain.Tracks
---@operator call: domain.Tracks
local Tracks = class()

---@param filesRepo domain.IFilesRepo
---@param tracksRepo domain.ITracksRepo
function Tracks:new(filesRepo, tracksRepo)
	self.filesRepo = filesRepo
	self.tracksRepo = tracksRepo
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
	local osz, err = osu_util.parse_osz(_file.tmpname)
	if not osz then
		assert(os.remove(_file.tmpname))
		return nil, err
	end

	local hash = _file.hash
	local d_file = File(hash)
	assert(os.rename(_file.tmpname, d_file:get_path()))

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
			created_at = os.time(),
		})
	end

	return track
end

return Tracks
