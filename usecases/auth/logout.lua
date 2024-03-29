local Usecase = require("http.Usecase")

---@class usecases.Logout: http.Usecase
---@operator call: usecases.Logout
local Logout = Usecase + {}

function Logout:handle(params)
	params.session.user_id = nil
	return "ok"
end

return Logout
