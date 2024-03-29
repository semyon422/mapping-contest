local Usecase = require("http.Usecase")

---@class usecases.LoginAs: http.Usecase
---@operator call: usecases.LoginAs
local LoginAs = Usecase + {}

function LoginAs:handle(params)
	params.session.user_id = params.user_id
	return "ok"
end

return LoginAs
