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

function ChartRepacker:repackPartial(path_in, out)
	local files = {}

	local _in = self.archiveFactory:open(path_in, "r")
	for info in _in:files() do
		_in:open_file()
		local data = _in:read(info.uncompressed_size)
		_in:close_file()
		files[info.filename] = data
	end
	_in:close()

	local new_files = self.fileConverter:convert(files)
	for filename, data in pairs(new_files) do
		out:add_file(filename)
		out:write(data)
		out:close_file()
	end
end

function ChartRepacker:repack(paths, path_out)
	local out = self.archiveFactory:open(path_out, "w")
	for _, path_in in ipairs(paths) do
		self:repackPartial(path_in, out)
	end
	out:close()
end

return ChartRepacker
