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

function ChartAnoner:anonOsu(osu, audio_hash, bg_hash, metadata, chart_name)
	osu.sections.General.AudioFilename = ("%08X.%s"):format(
		audio_hash, osu.sections.General.AudioFilename:match('%.(.-)$')
	)
	osu.background = ("%08X.%s"):format(bg_hash, osu.background:match('%.(.-)$'))

	local md = osu.sections.Metadata
	for k, v in pairs(defaults) do
		v = metadata[k] or v
		md[k] = v
	end
	md.Creator = chart_name
	md.Version = chart_name

	return ("%s - %s (%s) [%s].osu"):format(md.Artist, md.Title, md.Creator, md.Version)
end

---@param files table
---@param options table
---@return table
function ChartAnoner:convert(files, options)
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

	local filename = self:anonOsu(
		osu,
		crc32.hash(files[audio_file_name] or ""),
		crc32.hash(files[bg_file_name] or ""),
		options[1],
		options[2]
	)

	new_files[filename] = osu:encode()
	new_files[osu.sections.General.AudioFilename] = files[audio_file_name]
	new_files[osu.background] = files[bg_file_name]

	return new_files
end

return ChartAnoner
