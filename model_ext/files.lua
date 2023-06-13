local Filehash = require("util.filehash")

local File = {}

function File:get_path()
	local hash = Filehash:to_name(self.hash)
	return "storages/" .. hash
end

function File:exists()
	local f = io.open(self:get_path(), "r")
	if f then
		f:close()
		return true
	end
	return false
end

function File:write_file(content)
	local path = self:get_path()
	local f = assert(io.open(path, "wb"))
	f:write(content)
	f:close()
end

function File:read_file()
	local path = self:get_path()
	local f = assert(io.open(path, "rb"))
	local content = f:read("*a")
	f:close()

	return content
end

function File:delete_file()
	local path = self:get_path()
	os.remove(path)
end

return File
