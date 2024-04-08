local class = require("class")

---@class domain.ChartRepacker
---@operator call: domain.ChartRepacker
local ChartRepacker = class()

---@param archiveFactory domain.IArchiveFactory
---@param fileConverter domain.IFileConverter?
function ChartRepacker:new(archiveFactory, fileConverter)
	self.archiveFactory = archiveFactory
	self.fileConverter = fileConverter
end

---@param out domain.IArchive
---@param added_files table
---@param path_in string
---@param options table
function ChartRepacker:repackPartial(out, added_files, path_in, options)
	local files = {}

	local _in = self.archiveFactory:open(path_in, "r")
	for info in _in:files() do
		_in:open_file()
		local data = _in:read(info.uncompressed_size)
		_in:close_file()
		files[info.filename] = data
	end
	_in:close()

	local new_files = files
	if self.fileConverter then
		new_files = self.fileConverter:convert(files, options)
	end

	for filename, data in pairs(new_files) do
		if not added_files[filename] then
			out:add_file(filename)
			out:write(data)
			out:close_file()
			added_files[filename] = true
		end
	end
end

---@param paths table
---@param path_out string
function ChartRepacker:repack(paths, path_out)
	local out = self.archiveFactory:open(path_out, "w")
	local added_files = {}
	for _, po in ipairs(paths) do
		local path_in, options = unpack(po)
		self:repackPartial(out, added_files, path_in, options)
	end
	out:close()
end

return ChartRepacker
