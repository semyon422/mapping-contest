local Usecase = require("http.Usecase")

---@class usecases.OAuth: http.Usecase
---@operator call: usecases.OAuth
local OAuth = Usecase + {}

function OAuth:handle(params)
	local user = self.domain.auth:oauth(self.config.osu_oauth, params.code)
	assert(user)

	params.session.user_id = user.id
	return "ok"
end

return OAuth
