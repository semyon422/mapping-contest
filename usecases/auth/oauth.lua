local Usecase = require("usecases.Usecase")
local http = require("lapis.nginx.http")
local config = require("lapis.config").get()
local lapis_util = require("lapis.util")

local oauth = Usecase()

oauth:setHandler(function(params, models)
	local body, status_code = http.simple("https://osu.ppy.sh/oauth/token", {
		client_id = config.osu_oauth.client_id,
		client_secret = config.osu_oauth.client_secret,
		code = params.code,
		grant_type = "authorization_code",
		redirect_uri = config.osu_oauth.redirect_uri,
	})

	if status_code ~= 200 then
		return "error", body
	end

	local res = lapis_util.from_json(body)

	body, status_code = http.simple({
		url = "https://osu.ppy.sh/api/v2/me",
		method = "GET",
		headers = {["Authorization"] = "Bearer " .. res.access_token}
	})

	if status_code ~= 200 then
		return "error", body
	end

	local me = lapis_util.from_json(body)

	local user = models.users:select({osu_id = me.id})[1]
	if user then
		params.session.user_id = user.id
		user:update({
			name = me.username,
			discord = tostring(me.discord) or "",
		})
		return "ok", params
	end

	local time = os.time()
	user = models.users:insert({
		osu_id = me.id,
		name = me.username,
		discord = tostring(me.discord) or "",
		password = "",
		latest_activity = time,
		created_at = time,
	})

	models.user_roles:insert({
		user_id = user.id,
		role = "verified",
	})

	params.session.user_id = user.id
	return "ok", params
end)

return oauth
