local Usecase = require("http.Usecase")

---@class usecases.DeleteContest: http.Usecase
---@operator call: usecases.DeleteContest
local DeleteContest = Usecase + {}

function DeleteContest:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

function DeleteContest:handle(params)
	self.domain.contests:deleteContest(params.contest_id)
	return "deleted", params
end

return DeleteContest
