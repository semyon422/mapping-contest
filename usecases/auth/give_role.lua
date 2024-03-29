local Usecase = require("http.Usecase")

---@class usecases.GiveRole: http.Usecase
---@operator call: usecases.GiveRole
local GiveRole = Usecase + {}

function GiveRole:handle(params)
	self.domain.roles:give(params.user_id, params.role)
	return "ok"
end

return GiveRole
