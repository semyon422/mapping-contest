local Usecase = require("http.Usecase")

---@class usecases.GiveRole: http.Usecase
---@operator call: usecases.GiveRole
local GiveRole = Usecase + {}

function GiveRole:authorize(params)
	if not params.session_user then return end
	return self.domain.auth:canChangeRole(params.session_user, params.user)
end

function GiveRole:handle(params)
	self.domain.roles:give(params.user_id, params.role)
	return "ok", params
end

return GiveRole
