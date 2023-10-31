local etlua = require("etlua")

local mt = {}
local views = setmetatable({}, mt)

local loaders = {}

function loaders.lua(chunk, chunkname)
	return assert(load(chunk, "@" .. chunkname, "t"))()
end

local function render_subtemplate(name, params)
	return views[name](params, true)
end

local layout_f = assert(io.open("views/layout.etlua"))
local layout = etlua.compile(layout_f:read("a"))
layout_f:close()

function loaders.etlua(chunk, chunkname)
	local template = assert(etlua.compile(chunk))
	return function(result, no_layout)
		result.render = function(name, params)
			local env = setmetatable(params or {}, {__index = result})
			return render_subtemplate(name, env)
		end
		local content = template(result)
		if not no_layout then
			local env = setmetatable({}, {__index = result})
			env.inner = template(result)
			content = layout(env)
		end
		return content, {
			["Content-Type"] = "text/html"
		}
	end
end

---@param t table
---@param mod_name string
---@return any?
function mt.__index(t, mod_name)
	local path = "views/" .. mod_name:gsub("%.", "/")

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

return views
