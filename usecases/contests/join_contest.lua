local Usecase = require("http.Usecase")

---@class usecases.JoinContest: http.Usecase
---@operator call: usecases.JoinContest
local JoinContest = Usecase + {}

function JoinContest:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:canJoinContest(params.session_user)
end

function JoinContest:handle(params)
	self.domain.contestUsers:joinContest(params.contest_id, params.session.user_id)

	return "ok", params
end

return JoinContest
