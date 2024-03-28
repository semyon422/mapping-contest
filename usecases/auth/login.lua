local Recaptcha = require("util.Recaptcha")
local Usecase = require("http.Usecase")

---@class usecases.Login: http.Usecase
---@operator call: usecases.Login
local Login = Usecase + {}

function Login:authorize(params)
	if not params.session_user then return end
	return not self.domain.auth:isLoggedIn(params.session_user)
end

Login.validate = {
	name = {"*", "string", {"#", 1, 64}},
	password = {"*", "string", {"#", 1, 64}},
}

function Login:handle(params)
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

	local user, err = self.domain.auth:login(params.name, params.password)

	if not user then
		params.errors = {err}
		return "validation", params
	end

	params.session.user_id = user.id

	return "ok", params
end

return Login
