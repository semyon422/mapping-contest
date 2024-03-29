local Usecase = require("http.Usecase")

---@class usecases.RemoveRole: http.Usecase
---@operator call: usecases.RemoveRole
local RemoveRole = Usecase + {}

function RemoveRole:authorize(params)
	if not params.session_user then return end
	return self.domain.auth:canChangeRole(params.session_user, params.user)
end

function RemoveRole:handle(params)
	self.domain.roles:take(params.user_id, params.role)
	return "ok", params
end

return RemoveRole
