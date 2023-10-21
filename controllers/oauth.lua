local http = require("lapis.nginx.http")
local config = require("lapis.config").get()
local lapis_util = require("lapis.util")
local Users = require("models.users")
local User_roles = require("models.user_roles")
local Roles = require("enums.roles")

local oauth_c = {}

function oauth_c.GET(self)
	local params = self.params

	local body, status_code = http.simple("https://osu.ppy.sh/oauth/token", {
		client_id = config.osu_oauth.client_id,
		client_secret = config.osu_oauth.client_secret,
		code = params.code,
		grant_type = "authorization_code",
		redirect_uri = config.osu_oauth.redirect_uri,
	})

	if status_code ~= 200 then
		return body
	end

	local res = lapis_util.from_json(body)

	body, status_code = http.simple({
		url = "https://osu.ppy.sh/api/v2/me",
		method = "GET",
		headers = {["Authorization"] = "Bearer " .. res.access_token}
	})

	if status_code ~= 200 then
		return body
	end

	local me = lapis_util.from_json(body)

	local user = Users:find({osu_id = me.id})
	if user then
		self.session.user_id = user.id
		user.name = me.username
		user.discord = me.discord or ""
		user:update("name", "discord")
		return {redirect_to = self:url_for("home")}
	end

	local time = os.time()
	user = Users:create({
		osu_id = me.id,
		name = me.username,
		discord = me.discord or "",
		password = "",
		latest_activity = time,
		created_at = time,
	})

	User_roles:create({
		user_id = user.id,
		role = Roles:for_db("verified"),
	})

	self.session.user_id = user.id
	return {redirect_to = self:url_for("home")}
end

return oauth_c
