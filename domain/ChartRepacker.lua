local class = require("class")

---@class domain.ChartRepacker
---@operator call: domain.ChartRepacker
local ChartRepacker = class()

---@param archiveFactory domain.IArchiveFactory
---@param fileConverter domain.IFileConverter
function ChartRepacker:new(archiveFactory, fileConverter)
	self.archiveFactory = archiveFactory
	self.fileConverter = fileConverter
end

function ChartRepacker:repack(path_in, path_out)
	local _in = self.archiveFactory:open(path_in, "r")
	local out = self.archiveFactory:open(path_out, "w")

	local filename, data
	for info in _in:files() do
		_in:open_file()
		data = _in:read(info.uncompressed_size)
		_in:close_file()
		filename, data = self.fileConverter:convert(info.filename, data)
		out:add_file(filename)
		out:write(data)
		out:close_file()
	end

	_in:close()
	out:close()
end

return ChartRepacker
