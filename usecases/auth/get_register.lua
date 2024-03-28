local Usecase = require("http.Usecase")

---@class usecases.GetRegister: http.Usecase
---@operator call: usecases.GetRegister
local GetRegister = Usecase + {}

function GetRegister:authorize(params)
	if not params.session_user then return end
	return not self.domain.auth:isLoggedIn(params.session_user)
end

function GetRegister:handle(params)
	local config = self.config

	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_register_captcha_enabled

	return "ok", params
end

return GetRegister
