local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.UpdateVote: web.Usecase
---@operator call: usecases.UpdateVote
local UpdateVote = Usecase + {}

function UpdateVote:handle(params)
	self.domain.votes:updateVote(
		params.session_user,
		params.contest_id,
		params.chart_id,
		params.vote,
		tonumber(params.value)
	)
	return "ok"
end

return UpdateVote
