local config = require("lapis.config").get()

local get_register = {}

get_register.policy_set = {{"not_authed"}}

function get_register.handler(params, models)
	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_register_captcha_enabled

	return "ok", params
end

return get_register