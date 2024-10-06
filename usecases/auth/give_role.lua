local Usecase = require("web.usecase.Usecase")

---@class usecases.GiveRole: web.Usecase
---@operator call: usecases.GiveRole
local GiveRole = Usecase + {}

function GiveRole:handle(params)
	self.domain.roles:give(params.user_id, params.role)
	return "ok"
end

return GiveRole
