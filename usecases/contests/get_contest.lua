local Errors = require("domain.Errors")
local Usecase = require("http.Usecase")

---@class usecases.GetContest: http.Usecase
---@operator call: usecases.GetContest
local GetContest = Usecase + {}

function GetContest:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestAccessable(params.session_user, params.contest)
end

function GetContest:handle(params)
	local contest, err = self.domain.contests:getContest(params.session_user, params.contest_id)
	if not contest then
		if err == Errors.not_found then
			return "not_found", params
		end
		error("unknown error")
	end
	params.contest = contest

	return "ok", params
end

return GetContest
