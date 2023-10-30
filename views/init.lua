local etlua = require("etlua")

local mt = {}

local loaders = {}

function loaders.lua(chunk, chunkname)
	return assert(load(chunk, "@" .. chunkname, "t"))()
end

function loaders.etlua(chunk, chunkname)
	local template = assert(etlua.compile(chunk))
	return function(result)
		return template(result), {
			["Content-Type"] = "text/html"
		}
	end
end

---@param t table
---@param mod_name string
---@return any?
function mt.__index(t, mod_name)
	local path = "views/" .. mod_name

	local mod
	for _, ext in ipairs({"lua", "etlua"}) do
		local full_path = path .. "." .. ext
		local f = io.open(full_path)
		if f then
			local c = f:read("*a")
			local loader = loaders[ext]
			mod = loader(c, full_path)
			break
		end
	end
	assert(mod, "view '" .. mod_name .. "' not found")

	t[mod_name] = mod
	return mod
end

return setmetatable({}, mt)
