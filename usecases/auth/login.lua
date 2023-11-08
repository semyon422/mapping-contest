local config = require("lapis.config").get()
local recaptcha_verify = require("util.recaptcha_verify")
local bcrypt = require("bcrypt")
local types = require("lapis.validate.types")

local login = {}

login.policy_set = {{"not_authed"}}

login.validate = types.partial({
	name = types.limited_text(64),
	password = types.limited_text(64),
	["g-recaptcha-response"] = types.string + types.empty,
})

local failed = "Login failed. Invalid email or password"
local function _login(users, name, password)
	if not name or not password then return false, failed end
	local user = users:select({name = name})[1]
	if not user then return false, failed end
	local valid = bcrypt.verify(password, user.password)
	if valid then return user end
	return false, failed
end

function login.handler(params, models)
	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_login_captcha_enabled

	if config.is_login_captcha_enabled then
		local success, message = recaptcha_verify(
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

	local user, err = _login(models.users, params.name, params.password)

	if not user then
		params.errors = {err}
		return "validation", params
	end

	params.session.user_id = user.id

	return "ok", params
end

return login
