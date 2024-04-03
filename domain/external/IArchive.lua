local class = require("class")

---@class domain.IArchive
---@operator call: domain.IArchive
local IArchive = class()

function IArchive:close()
end

---@return fun(): domain.ArchiveFileInfo?
function IArchive:files()
	return function() end
end

---@param filename string
function IArchive:add_file(filename)
end

---@param size number
---@return string
function IArchive:read(size)
	return ""
end

---@param s string
function IArchive:write(s)
end

function IArchive:open_file()
end

function IArchive:close_file()
end

---@return table
function IArchive:get_file_info()
	return {}
end

return IArchive
