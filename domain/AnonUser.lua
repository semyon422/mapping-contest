local class = require("class")

---@class domain.AnonUser
---@operator call: domain.AnonUser
local AnonUser = class()

function AnonUser:new()
	self.user_roles = {}
end

return AnonUser
