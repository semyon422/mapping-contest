local class = require("class")

---@class domain.AnonUser
---@operator call: domain.AnonUser
local AnonUser = class()

AnonUser.id = 0

function AnonUser:new()
	self.user_roles = {}
end

return AnonUser
