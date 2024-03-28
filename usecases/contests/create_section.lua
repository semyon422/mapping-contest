local Usecase = require("http.Usecase")

---@class usecases.CreateSection: http.Usecase
---@operator call: usecases.CreateSection
local CreateSection = Usecase + {}

function CreateSection:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

function CreateSection:handle(params)
	local section, err = self.domain.sections:createSsection(params.session_user, params.contest_id, {
		contest_id = params.contest.id,
		name = params.name,
		time_base = tonumber(params.time_base) or 0,
		time_per_knote = tonumber(params.time_per_knote) or 0,
	})
	assert(section)

	return "ok", params
end

return CreateSection
