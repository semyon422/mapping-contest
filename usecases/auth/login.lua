local Recaptcha = require("util.Recaptcha")
local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.Login: web.Usecase
---@operator call: usecases.Login
local Login = Usecase + {}

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
			return "validation"
		end
	end

	local user, err = self.domain.auth:login(params.name, params.password)

	if not user then
		params.errors = {err}
		return "validation"
	end

	params.session.user_id = user.id

	return "ok"
end

return Login
