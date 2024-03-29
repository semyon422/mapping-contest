local Recaptcha = require("util.Recaptcha")
local Usecase = require("http.Usecase")

---@class usecases.Register: http.Usecase
---@operator call: usecases.Register
local Register = Usecase + {}

function Register:handle(params)
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
			return "validation"
		end
	end

	local user = self.domain.auth:register(params.name, params.password, params.discord)
	assert(user)

	params.session.user_id = user.id

	return "ok"
end

return Register
