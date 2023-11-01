local Usecase = require("usecases.Usecase")
local config = require("lapis.config").get()
local http_util = require("http_util")

local login_osu = Usecase()

login_osu:setPolicySet({{"not_authed"}})

login_osu:setHandler(function(params, models)
	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_login_captcha_enabled

	params.osu_authorize_url = "https://osu.ppy.sh/oauth/authorize?" .. http_util.encode_query_string({
		client_id = config.osu_oauth.client_id,
		redirect_uri = config.osu_oauth.redirect_uri,
		response_type = "code",
		scope = "identify",
		state = "csrf_token",
	})

	return "ok", params
end)

return login_osu
