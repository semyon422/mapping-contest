local bcrypt = require("bcrypt")
local Users = require("models.users")
local config = require("lapis.config").get()
local util = require("util")
local lapis_util = require("lapis.util")

local login_c = {}

function login_c.GET(self)
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

local failed = "Login failed. Invalid email or password"
local function login(name, password)
	if not name or not password then return false, failed end
	local user = Users:find({name = name})
	if not user then return false, failed end
	local valid = bcrypt.verify(password, user.password)
	if valid then return user end
	return false, failed
end

function login_c.POST(self)
	local params = self.params

	self.ctx.recaptcha_site_key = config.recaptcha.site_key
	self.ctx.is_captcha_enabled = config.is_login_captcha_enabled

	if config.is_login_captcha_enabled then
		local success, message = util.recaptcha_verify(
			self.ctx.ip,
			params["g-recaptcha-response"],
			"login",
			0.5
		)
		if not success then
			self.errors = {message}
			return {render = true}
		end
	end

	local user, err = login(params.name, params.password)

	if not user then
		self.errors = {err}
		return {render = true}
	end

	self.session.user_id = user.id

	return {redirect_to = self:url_for("home")}
end

return login_c
