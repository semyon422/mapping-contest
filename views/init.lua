local etlua_util = require("etlua_util")
local Usecase = require("http.Usecase")

local mt = {}
local views = setmetatable({}, mt)

local loaders = {}

function loaders.lua(chunk, chunkname)
	return assert(load(chunk, "@" .. chunkname, "t"))()
end

local function render_subtemplate(name, params)
	return views[name](params, true)
end

local View = {}
View.__index = View

function View:render(name)
	return render_subtemplate(name, self.env)
end

function View:authorize(usecase_name)
	local usecase = require("usecases." .. usecase_name)
	local policy_set = usecase.policy_set

	local uc = Usecase()
	if policy_set then
		uc:setPolicySet(policy_set)
	end

	return uc:authorize(self.env) == "permit"
end

local function new_viewable_env(env)
	local new_env = setmetatable({}, {__index = env})
	new_env.view = setmetatable({env = new_env}, View)
	return new_env
end

function View:__call(env)
	setmetatable(env, {__index = self.env})
	return new_viewable_env(env).view
end

-- local function test()
-- 	local wenv = new_viewable_env({session_user = {id = 1}})
-- 	local wenv2 = wenv.view({role = 1}).env
-- 	local wenv3 = wenv2.view({a = 1}).env
-- 	assert(wenv3.session_user.id == 1)
-- 	assert(wenv3.role == 1)
-- 	assert(wenv3.a == 1)
-- end
-- test()

local layout_f = assert(io.open("views/layout.etlua"))
local layout = etlua_util.compile(layout_f:read("a"), "views/layout.etlua")
layout_f:close()

function loaders.etlua(chunk, chunkname)
	local template = assert(etlua_util.compile(chunk, chunkname))
	return function(result, no_layout)
		local content = template(new_viewable_env(result))
		if not no_layout then
			local l_env = new_viewable_env(result)
			l_env.inner = content
			content = layout(l_env)
		end
		return content
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
