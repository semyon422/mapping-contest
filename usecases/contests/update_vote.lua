local Usecase = require("http.Usecase")

---@class usecases.UpdateVote: http.Usecase
---@operator call: usecases.UpdateVote
local UpdateVote = Usecase + {}

function UpdateVote:handle(params)
	self.domain.votes:updateVote(params.contest_id, params.session.user_id, params.chart_id, params.vote)
	return "ok"
end

return UpdateVote
