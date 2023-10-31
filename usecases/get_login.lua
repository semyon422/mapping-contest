local Usecase = require("usecases.Usecase")
local config = require("lapis.config").get()

local get_login = Usecase()

function get_login:run(params, models)
	if params.session.user_id then
		return "forbidden", {}
	end

	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_register_captcha_enabled

	return "ok", params
end

return get_login