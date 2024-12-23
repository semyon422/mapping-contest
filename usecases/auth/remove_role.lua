local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.RemoveRole: web.Usecase
---@operator call: usecases.RemoveRole
local RemoveRole = Usecase + {}

function RemoveRole:handle(params)
	self.domain.roles:take(params.user_id, params.role)
	return "ok"
end

return RemoveRole
