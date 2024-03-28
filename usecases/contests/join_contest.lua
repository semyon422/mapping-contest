local Usecase = require("http.Usecase")

---@class usecases.JoinContest: http.Usecase
---@operator call: usecases.JoinContest
local JoinContest = Usecase + {}

function JoinContest:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:canJoinContest(params.session_user, params.contest)
end

JoinContest.models = {contest = {"contests", {id = "contest_id"}}}

function JoinContest:handle(params)
	self.models.contest_users:create({
		contest_id = params.contest_id,
		user_id = params.session.user_id,
		started_at = os.time(),
	})

	return "ok", params
end

return JoinContest
