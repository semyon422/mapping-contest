local IFileConverter = require("domain.IFileConverter")
local Osu = require("domain.Osu")
local crc32 = require("crc32")

---@class domain.ChartAnoner: domain.IFileConverter
---@operator call: domain.ChartAnoner
local ChartAnoner = IFileConverter + {}

local defaults = {
	Title = "",
	TitleUnicode = "",
	Artist = "",
	ArtistUnicode = "",
	Creator = "",
	Version = "",
	Source = "",
	Tags = "",
	BeatmapID = "0",
	BeatmapSetID = "-1",
}

function ChartAnoner:new(metadata, chart_name)
	self.metadata = metadata
	self.chart_name = chart_name
end

function ChartAnoner:anonOsu(osu, audio_hash, bg_hash)
	local md = self.metadata

	osu.sections.General.AudioFilename = ("%08X.%s"):format(
		audio_hash, osu.sections.General.AudioFilename:match('%.(.-)$')
	)
	osu.background = ("%08X.%s"):format(bg_hash, osu.background:match('%.(.-)$'))

	-- local AudioFilename = osu.sections.General.AudioFilename
	-- osu.sections.General.AudioFilename = ("%s - %s.%s"):format(
	-- 	md.Artist, md.Title, AudioFilename:match('%.(.-)$')
	-- )
	-- osu.background = ("%s - %s (%s).%s"):format(md.Artist, md.Title, md.Creator, osu.background:match('%.(.-)$'))

	for k, v in pairs(defaults) do
		v = md[k] or v
		osu.sections.Metadata[k] = v
	end
	osu.sections.Metadata.Creator = self.chart_name
	osu.sections.Metadata.Version = self.chart_name

	return ("%s - %s (%s) [%s].osu"):format(md.Artist, md.Title, md.Creator, md.Version)
end

---@param files table
---@return table
function ChartAnoner:convert(files)
	local new_files = {}

	local osu_file_name, osu_file_size
	for filename, data in pairs(files) do
		if filename:find("%.osu$") and (not osu_file_size or osu_file_size < #data) then
			osu_file_name = filename
			osu_file_size = #data
		end
	end

	local osu = Osu()
	osu:decode(files[osu_file_name])

	local audio_file_name = osu.sections.General.AudioFilename
	local bg_file_name = osu.background

	local filename = self:anonOsu(osu, crc32.hash(files[audio_file_name]), crc32.hash(files[bg_file_name]))

	new_files[filename] = osu:encode()
	new_files[osu.sections.General.AudioFilename] = files[audio_file_name]
	new_files[osu.background] = files[bg_file_name]

	return new_files
end

return ChartAnoner
