local Usecase = require("http.Usecase")

---@class usecases.JoinContest: http.Usecase
---@operator call: usecases.JoinContest
local JoinContest = Usecase + {}

function JoinContest:handle(params)
	self.domain.contestUsers:joinContest(params.contest_id, params.session.user_id)

	return "ok"
end

return JoinContest
