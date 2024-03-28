local Usecase = require("http.Usecase")

---@class usecases.LoginAs: http.Usecase
---@operator call: usecases.LoginAs
local LoginAs = Usecase + {}

function LoginAs:authorize(params)
	if not params.session_user then return end
	return self.domain.auth:canLoginAs(params.session_user, params.user)
end

LoginAs.validate = {
	user_id = "integer",
}

function LoginAs:handle(params)
	params.session.user_id = params.user_id

	return "ok", params
end

return LoginAs
