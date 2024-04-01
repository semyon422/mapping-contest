local class = require("class")

---@class domain.IOsuApi
---@operator call: domain.IOsuApi
local IOsuApi = class()

IOsuApi.access_token = nil
IOsuApi.oauth_config = nil

---@param oauth_config table
function IOsuApi:new(oauth_config)
end

---@param code any
function IOsuApi:oauth(code)
end

---@return table?
---@return string?
function IOsuApi:me()
end

return IOsuApi
