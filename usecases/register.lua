local Usecase = require("usecases.Usecase")
local config = require("lapis.config").get()
local util = require("util")
local bcrypt = require("bcrypt")

local register = Usecase()

register:setPolicySet({{"not_authed"}})

register:setHandler(function(params, models)
	params.recaptcha_site_key = config.recaptcha.site_key
	params.is_captcha_enabled = config.is_register_captcha_enabled

	if config.is_register_captcha_enabled then
		local success, message = util.recaptcha_verify(
			params.ip,
			params["g-recaptcha-response"],
			"register",
			0.5
		)
		if not success then
			params.errors = {message}
			return "ok", params
		end
	end

	local user = models.users:select({name = params.name})[1]
	if user then
		params.errors = {"This name is already taken"}
		return "ok", params
	end

	local time = os.time()
	user = models.users:create({
		osu_id = 0,
		name = params.name,
		discord = params.discord,
		password = bcrypt.digest(params.password, 10),
		latest_activity = time,
		created_at = time,
	})

	params.session.user_id = user.id

	return "ok", params
end)

return register
