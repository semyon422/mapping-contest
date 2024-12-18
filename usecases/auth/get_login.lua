local http_util = require("http_util")
local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.GetLogin: web.Usecase
---@operator call: usecases.GetLogin
local GetLogin = Usecase + {}

function GetLogin:handle(params)
	local config = self.config

	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_register_captcha_enabled

	params.osu_authorize_url = "https://osu.ppy.sh/oauth/authorize?" .. http_util.encode_query_string({
		client_id = config.osu_oauth.client_id,
		redirect_uri = config.osu_oauth.redirect_uri,
		response_type = "code",
		scope = "identify",
		state = "csrf_token",
	})

	return "ok"
end

return GetLogin
