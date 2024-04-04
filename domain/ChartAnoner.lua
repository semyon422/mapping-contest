local IFileConverter = require("domain.IFileConverter")

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

function ChartAnoner:new(metadata)
	self.metadata = metadata
end

function ChartAnoner:anonOsu(s)
	local md = self.metadata
	for k, v in pairs(defaults) do
		v = md[k] or v
		s = s:gsub(k .. ":[^\n]+", k .. ":" .. v)
	end
	local filename = ("%s - %s (%s) [%s].osu"):format(md.Artist, md.Title, md.Creator, md.Version)
	return filename, s
end

---@param filename string
---@param data string
---@return string
---@return string
function ChartAnoner:convert(filename, data)
	if filename:find("%.osu$") then
		filename, data = self:anonOsu(data)
	end
	return filename, data
end

return ChartAnoner
