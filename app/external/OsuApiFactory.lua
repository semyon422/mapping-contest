local IOsuApiFactory = require("domain.external.IOsuApiFactory")
local OsuApi = require("app.external.OsuApi")

---@class app.OsuApiFactory: domain.IOsuApiFactory
---@operator call: app.OsuApiFactory
local OsuApiFactory = IOsuApiFactory + {}

---@param oauth_config table
function OsuApiFactory:new(oauth_config)
	self.oauth_config = oauth_config
end

---@return app.OsuApi
function OsuApiFactory:getOsuApi()
	return OsuApi(self.oauth_config)
end

return OsuApiFactory
