local Usecase = require("http.Usecase")

---@class usecases.DeleteContest: http.Usecase
---@operator call: usecases.DeleteContest
local DeleteContest = Usecase + {}

function DeleteContest:handle(params)
	self.domain.contests:deleteContest(params.session_user, params.contest_id)
	return "deleted"
end

return DeleteContest
