local Users = require("models.users")
local preload = require("lapis.db.model").preload
local types = require("lapis.validate.types")
local with_params = require("lapis.validate").with_params
local bcrypt = require("bcrypt")

local user_c = {}

function user_c.GET(self)
	local ctx = self.ctx

	preload({ctx.user}, "user_roles")

	return {render = true}
end

user_c.PATCH = with_params({
	{"name", types.limited_text(64)},
	{"osu_url", types.limited_text(256)},
	{"discord", types.limited_text(64)},
	{"password", types.limited_text(64) + types.empty},
}, function(self, params)
	local ctx = self.ctx

	local _user = Users:find({name = params.name})
	if _user and _user.id ~= ctx.user.id then
		self.errors = {"This name is already taken"}
		return {render = "errors", layout = false}
	end

	local user = ctx.user
	user.name = params.name
	user.osu_url = params.osu_url
	user.discord = params.discord
	user:update("name", "osu_url", "discord")

	if params.password then
		user.password = bcrypt.digest(params.password, 10)
		user:update("password")
	end

	return {headers = {["HX-Location"] = self:url_for(user)}}
end)

return user_c
