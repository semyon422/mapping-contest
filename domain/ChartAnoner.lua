local IFileConverter = require("domain.IFileConverter")

---@class domain.ChartAnoner: domain.IFileConverter
---@operator call: domain.ChartAnoner
local ChartAnoner = IFileConverter + {}

function ChartAnoner:new(chart_name)
	self.chart_name = chart_name
end

function ChartAnoner:anonOsu(s)
	return s:gsub("Creator:[^\n]+", "Creator:" .. self.chart_name)
end

---@param filename string
---@param data string
---@return string
---@return string
function ChartAnoner:convert(filename, data)
	if filename:find("%.osu$") then
		data = self:anonOsu(data)
	end
	return filename, data
end

return ChartAnoner
