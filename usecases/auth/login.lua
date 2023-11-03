local config = require("lapis.config").get()
local util = require("util")
local bcrypt = require("bcrypt")

local get_login = {}

get_login.policy_set = {{"not_authed"}}

local failed = "Login failed. Invalid email or password"
local function login(users, name, password)
	if not name or not password then return false, failed end
	local user = users:select({name = name})[1]
	if not user then return false, failed end
	local valid = bcrypt.verify(password, user.password)
	if valid then return user end
	return false, failed
end

function get_login.handler(params, models)
	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_login_captcha_enabled

	if config.is_login_captcha_enabled then
		local success, message = util.recaptcha_verify(
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

	local user, err = login(models.users, params.name, params.password)

	if not user then
		params.errors = {err}
		return "validation", params
	end

	params.session.user_id = user.id

	return "ok", params
end

return get_login
