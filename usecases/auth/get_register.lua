local get_register = {}

get_register.access = {{"not_authed"}}

function get_register:handle(params)
	local config = self.config

	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_register_captcha_enabled

	return "ok", params
end

return get_register
