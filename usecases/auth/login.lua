local Recaptcha = require("util.Recaptcha")
local bcrypt = require("bcrypt")

local login = {}

login.access = {{"not_authed"}}

login.validate = {
	name = {"*", "string", {"#", 1, 64}},
	password = {"*", "string", {"#", 1, 64}},
	["g-recaptcha-response"] = {"*", "string", {"#", 0, 1024}},
}

local failed = "Login failed. Invalid email or password"
local function _login(users, name, password)
	if not name or not password then return false, failed end
	local user = users:find({name = name})
	if not user then return false, failed end
	local valid = bcrypt.verify(password, user.password)
	if valid then return user end
	return false, failed
end

function login:handle(params)
	local config = self.config

	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_login_captcha_enabled

	if config.is_login_captcha_enabled then
		local recaptcha = Recaptcha(config.recaptcha.secret_key)
		local success, message = recaptcha:verify(
			params.ip,
			params["g-recaptcha-response"],
			"login",
			0.5
		)
		if not success then
			params.errors = {message}
			return "validation", params
		end
	end

	local user, err = _login(self.models.users, params.name, params.password)

	if not user then
		params.errors = {err}
		return "validation", params
	end

	params.session.user_id = user.id

	return "ok", params
end

return login
