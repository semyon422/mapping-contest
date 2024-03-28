local Usecase = require("http.Usecase")

---@class usecases.DeleteContest: http.Usecase
---@operator call: usecases.DeleteContest
local DeleteContest = Usecase + {}

function DeleteContest:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

DeleteContest.models = {contest = {"contests", {id = "contest_id"}}}

function DeleteContest:handle(params)
	params.contest:delete()
	return "deleted", params
end

return DeleteContest
