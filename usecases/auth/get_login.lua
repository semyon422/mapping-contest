local Usecase = require("usecases.Usecase")
local config = require("lapis.config").get()

local get_login = Usecase()

get_login:setPolicySet({{"not_authed"}})

get_login:setHandler(function(params, models)
	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_register_captcha_enabled

	return "ok", params
end)

return get_login
