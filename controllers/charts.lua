local Charts = require("models.charts")
local Files = require("models.files")
local Tracks = require("models.tracks")
local Contests = require("models.contests")
local Sections = require("enums.sections")
local Filehash = require("util.filehash")
local types = require("lapis.validate.types")
local with_params = require("lapis.validate").with_params
local osu_util = require("osu_util")

local charts_c = {}

charts_c.POST = with_params({
	{"contest_id", types.db_id},
	{"file", types.shape{
		content = types.string,
		filename = types.string,
		name = types.string,
		["content-type"] = types.string,
	}},
}, function(self, params)
	local _file = params.file

	local hash = Filehash:sum_for_db_raw(_file.content)

	local file = Files:find({hash = hash})
	if not file then
		file = Files:create({
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

	local track = Tracks:find({
		title = osz.Title,
		artist = osz.Artist,
	})
	if not track then
		-- file:delete_file()
		-- file:delete()
		-- return {status = 400, "track not found"}
		track = Tracks:create({
			file_id = file.id,
			title = osz.Title,
			artist = osz.Artist,
			created_at = os.time(),
		})
	end

	local contest = Contests:find(params.contest_id)
	local section = Sections:get_section(os.time() - contest.started_at, osz.HitObjects)

	local chart = Charts:create({
		track_id = track.id,
		charter_id = self.session.user_id,
		contest_id = params.contest_id,
		file_id = file.id,
		section = Sections:for_db(section),
		name = osz.Version,
		submitted_at = os.time(),
	})

	return {status = 201, headers = {
		["Location"] = self:url_for(chart)
	}}
end)

return charts_c
