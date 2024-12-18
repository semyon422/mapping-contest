local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.GetRegister: web.Usecase
---@operator call: usecases.GetRegister
local GetRegister = Usecase + {}

function GetRegister:handle(params)
	local config = self.config

	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_register_captcha_enabled

	return "ok"
end

return GetRegister
