local Usecase = require("http.Usecase")

---@class usecases.CreateContest: http.Usecase
---@operator call: usecases.CreateContest
local CreateContest = Usecase + {}

function CreateContest:handle(params)
	local contest, err = self.domain.contests:createContest(params.session_user)
	assert(contest)
	params.contest = contest

	return "created"
end

return CreateContest
