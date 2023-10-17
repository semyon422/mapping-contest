local bcrypt = require("bcrypt")
local Users = require("models.users")
local config = require("lapis.config").get()
local util = require("util")
local lapis_util = require("lapis.util")

local login_osu_c = {}

function login_osu_c.GET(self)
	if self.session.user_id then
		return {redirect_to = self:url_for("home")}
	end

	self.ctx.recaptcha_site_key = config.recaptcha.site_key
	self.ctx.is_captcha_enabled = config.is_login_captcha_enabled

	self.ctx.osu_authorize_url = "https://osu.ppy.sh/oauth/authorize?" .. lapis_util.encode_query_string({
		client_id = config.osu_oauth.client_id,
		redirect_uri = config.osu_oauth.redirect_uri,
		response_type = "code",
		scope = "identify",
		state = "csrf_token",
	})

	return {render = true}
end

return login_osu_c
