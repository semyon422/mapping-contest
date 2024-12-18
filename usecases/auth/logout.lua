local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.Logout: web.Usecase
---@operator call: usecases.Logout
local Logout = Usecase + {}

function Logout:handle(params)
	params.session.user_id = nil
	return "ok"
end

return Logout
