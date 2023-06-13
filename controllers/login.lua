local bcrypt = require("bcrypt")
local Users = require("models.users")

local login_c = {}

function login_c.GET(self)
	if self.session.user_id then
		return {redirect_to = self:url_for("home")}
	end

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
	if self.session.user_id then
		return {redirect_to = self:url_for("home")}
	end

	local ctx = self.ctx
	local params = self.params

	-- if config.is_login_captcha_enabled then
	-- 	local success, message = util.recaptcha_verify(
	-- 		self.ctx.ip,
	-- 		params.recaptcha_token,
	-- 		"login",
	-- 		0.5
	-- 	)
	-- 	if not success then
	-- 		return {json = {message = message}}
	-- 	end
	-- end

	local user, err = login(params.name, params.password)

	if not user then
		self.errors = {err}
		return {render = true}
	end

	self.session.user_id = user.id

	return {redirect_to = self:url_for("home")}
end

return login_c
