local Usecase = require("http.Usecase")

---@class usecases.UpdateVote: http.Usecase
---@operator call: usecases.UpdateVote
local UpdateVote = Usecase + {}

function UpdateVote:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:canVote(params.session_user, params.contest, params.chart)
end

function UpdateVote:handle(params)
	self.domain.votes:updateVote(params.contest_id, params.session.user_id, params.chart_id, params.vote)

	return "ok", params
end

return UpdateVote
