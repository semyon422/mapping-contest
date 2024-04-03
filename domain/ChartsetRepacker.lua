local class = require("class")

---@class domain.ChartsetRepacker
---@operator call: domain.ChartsetRepacker
local ChartsetRepacker = class()

---@param archiveFactory domain.IArchiveFactory
function ChartsetRepacker:new(archiveFactory)
	self.archiveFactory = archiveFactory
end

local function anonymizeOsu(s)
	return s:gsub("Creator:[^\n]+", "Creator:anon")
end

function ChartsetRepacker:repack(path_in, path_out)
	local _in = self.archiveFactory:open(path_in, "r")
	local out = self.archiveFactory:open(path_out, "w")
	for info in _in:files() do
		_in:open_file()
		local content = _in:read(info.uncompressed_size)
		_in:close_file()
		if info.filename:find("%.osu$") then
			content = anonymizeOsu(content)
		end
		out:add_file(info.filename)
		out:write(content)
		out:close_file()
	end
	_in:close()
	out:close()
end

return ChartsetRepacker
