local http = require("lapis.nginx.http")
local lapis_util = require("lapis.util")
local IOsuApi = require("domain.external.IOsuApi")

---@class app.OsuApi: domain.IOsuApi
---@operator call: app.OsuApi
local OsuApi = IOsuApi + {}

---@param oauth_config table
function OsuApi:new(oauth_config)
	self.oauth_config = oauth_config
end

---@param code any
function OsuApi:oauth(code)
	local oauth_config = self.oauth_config

	local body, status_code = http.simple("https://osu.ppy.sh/oauth/token", {
		client_id = oauth_config.client_id,
		client_secret = oauth_config.client_secret,
		redirect_uri = oauth_config.redirect_uri,
		grant_type = "authorization_code",
		code = code,
	})

	if status_code ~= 200 then
		return nil, body
	end

	local res = lapis_util.from_json(body)
	self.access_token = res.access_token

	return true
end

---@return table?
---@return string?
function OsuApi:me()
	local body, status_code = http.simple({
		url = "https://osu.ppy.sh/api/v2/me",
		method = "GET",
		headers = {["Authorization"] = ("Bearer %s"):format(self.access_token)}
	})

	if status_code ~= 200 then
		return nil, body
	end

	return lapis_util.from_json(body)
end

return OsuApi
