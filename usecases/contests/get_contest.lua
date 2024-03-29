local Errors = require("domain.Errors")
local Usecase = require("http.Usecase")

---@class usecases.GetContest: http.Usecase
---@operator call: usecases.GetContest
local GetContest = Usecase + {}

function GetContest:handle(params)
	local contest, err = self.domain.contests:getContest(params.session_user, params.contest_id)
	if not contest then
		if err == Errors.not_found then
			return "not_found"
		end
		error("unknown error")
	end
	params.contest = contest

	return "ok"
end

return GetContest
