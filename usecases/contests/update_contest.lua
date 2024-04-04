local Usecase = require("http.Usecase")

---@class usecases.UpdateContest: http.Usecase
---@operator call: usecases.UpdateContest
local UpdateContest = Usecase + {}

function UpdateContest:handle(params)
	self.domain.contests:updateContest(params.session_user, params.contest_id, {
		name = params.name,
		description = params.description,
		is_visible = params.is_visible,
		is_voting_open = params.is_voting_open,
		is_submission_open = params.is_submission_open,
		is_anon = params.is_anon,
	})
	return "ok"
end

return UpdateContest
