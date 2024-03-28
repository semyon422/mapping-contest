local Usecase = require("http.Usecase")

---@class usecases.Logout: http.Usecase
---@operator call: usecases.Logout
local Logout = Usecase + {}

function Logout:authorize(params)
	if not params.session_user then return end
	return self.domain.auth:isLoggedIn(params.session_user)
end

function Logout:handle(params)
	params.session.user_id = nil
	return "ok", params
end

return Logout
