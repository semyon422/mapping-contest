local class = require("class")

---@class domain.IOsuApiFactory
---@operator call: domain.IOsuApiFactory
local IOsuApiFactory = class()

---@param oauth_config table
function IOsuApiFactory:new(oauth_config)
end

---@return domain.IOsuApi
function IOsuApiFactory:getOsuApi()
	return {}
end

return IOsuApiFactory
