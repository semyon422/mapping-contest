local Usecase = require("http.Usecase")

---@class usecases.CreateContest: http.Usecase
---@operator call: usecases.CreateContest
local CreateContest = Usecase + {}

function CreateContest:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:canCreateContest(params.session_user)
end

function CreateContest:handle(params)
	local contest, err = self.domain.contests:createContest(params.session_user)
	assert(contest)
	params.contest = contest

	return "created", params
end

return CreateContest
