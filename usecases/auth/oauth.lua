local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.OAuth: web.Usecase
---@operator call: usecases.OAuth
local OAuth = Usecase + {}

function OAuth:handle(params)
	local user = assert(self.domain.auth:oauth(params.code))

	params.session.user_id = user.id
	return "ok"
end

return OAuth
