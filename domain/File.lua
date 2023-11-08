local class = require("class")

---@class domain.File
---@operator call: domain.File
local File = class()

function File:new(hash)
	self.hash = hash
end

function File:get_path()
	return "storages/" .. self.hash
end

function File:exists()
	local f = io.open(self:get_path(), "r")
	if f then
		f:close()
		return true
	end
	return false
end

function File:write(content)
	local path = self:get_path()
	local f = assert(io.open(path, "wb"))
	f:write(content)
	f:close()
end

function File:read()
	local path = self:get_path()
	local f = assert(io.open(path, "rb"))
	local content = f:read("*a")
	f:close()
	return content
end

function File:delete()
	local path = self:get_path()
	os.remove(path)
end

return File
