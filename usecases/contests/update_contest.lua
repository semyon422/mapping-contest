local Usecase = require("http.Usecase")

---@class usecases.UpdateContest: http.Usecase
---@operator call: usecases.UpdateContest
local UpdateContest = Usecase + {}

function UpdateContest:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

function UpdateContest:handle(params)
	self.domain.contests:updateContest({
		name = params.name,
		description = params.description,
		is_visible = params.is_visible,
		is_voting_open = params.is_voting_open,
		is_submission_open = params.is_submission_open,
	})
	return "ok", params
end

return UpdateContest
