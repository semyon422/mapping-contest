local IArchive = require("domain.external.IArchive")

---@class app.Archive: domain.IArchive
---@operator call: app.Archive
local Archive = IArchive + {}

function Archive:new(zip)
	self.z = zip
end

function Archive:close()
	self.z:close()
end

---@return fun(): domain.ArchiveFileInfo?
function Archive:files()
	return self.z:files()
end

---@param filename string
function Archive:add_file(filename)
	self.z:add_file(filename)
end

---@param size number
---@return string
function Archive:read(size)
	return self.z:read(size)
end

---@param s string
function Archive:write(s)
	self.z:write(s)
end

function Archive:open_file()
	self.z:open_file()
end

function Archive:close_file()
	self.z:close_file()
end

---@return table
function Archive:get_file_info()
	return self.z:get_file_info()
end

return Archive
