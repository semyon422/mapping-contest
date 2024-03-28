local Usecase = require("http.Usecase")

---@class usecases.RemoveRole: http.Usecase
---@operator call: usecases.RemoveRole
local RemoveRole = Usecase + {}

function RemoveRole:authorize(params)
	if not params.session_user then return end
	return self.domain.auth:canChangeRole(params.session_user, params.user)
end

RemoveRole.models = {user_role = {"user_roles", {"user_id", "role"}}}

function RemoveRole:handle(params)
	params.user_role:delete()
	return "ok", params
end

return RemoveRole
