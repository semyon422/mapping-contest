local Usecase = require("web.usecase.Usecase")

---@class usecases.LoginAs: web.Usecase
---@operator call: usecases.LoginAs
local LoginAs = Usecase + {}

function LoginAs:handle(params)
	params.session.user_id = params.user_id
	return "ok"
end

return LoginAs
