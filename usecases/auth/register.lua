local Recaptcha = require("util.Recaptcha")
local bcrypt = require("bcrypt")

local register = {}

register.access = {{"not_authed"}}

register.validate = {
	name = {"*", "string", {"#", 1, 64}},
	discord = {"*", "string", {"#", 1, 64}},
	password = {"*", "string", {"#", 1, 64}},
}

function register:handle(params)
	local config = self.config

	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_register_captcha_enabled

	if config.is_register_captcha_enabled then
		local recaptcha = Recaptcha(config.recaptcha.secret_key)
		local success, message = recaptcha:verify(
			params.ip,
			params["g-recaptcha-response"],
			"register",
			0.5
		)
		if not success then
			params.errors = {message}
			return "validation", params
		end
	end

	local user = self.models.users:find({name = params.name})
	if user then
		params.errors = {"This name is already taken"}
		return "validation", params
	end

	local time = os.time()
	user = self.models.users:create({
		osu_id = 0,
		name = params.name,
		discord = params.discord,
		password = bcrypt.digest(params.password, 10),
		latest_activity = time,
		created_at = time,
	})

	params.session.user_id = user.id

	return "ok", params
end

return register
