local bcrypt = require("bcrypt")
local Users = require("models.users")
local types = require("lapis.validate.types")
local with_params = require("lapis.validate").with_params

local register_c = {}

function register_c.GET(self)
	if self.session.user_id then
		return {redirect_to = self:url_for("home")}
	end

	return {render = true}
end

register_c.POST = with_params({
	{"name", types.limited_text(64)},
	{"osu_url", types.limited_text(256)},
	{"discord", types.limited_text(64)},
	{"password", types.limited_text(64)},
}, function(self, params)
	if self.session.user_id then
		return {redirect_to = self:url_for("home")}
	end

	local ctx = self.ctx

	-- local success, message = util.recaptcha_verify(
	-- 	self.ctx.ip,
	-- 	params.recaptcha_token,
	-- 	"register",
	-- 	0.5
	-- )
	-- if not success then
	-- 	return {json = {message = message}}
	-- end

	local user = Users:find({name = params.name})
	if user then
		self.errors = {"This name is already taken"}
		return {render = true}
	end

	local time = os.time()
	user = Users:create({
		name = params.name,
		osu_url = params.osu_url,
		discord = params.discord,
		password = bcrypt.digest(params.password, 10),
		latest_activity = time,
		created_at = time,
	})

	self.session.user_id = user.id

	return {redirect_to = self:url_for("home")}
end)

return register_c
