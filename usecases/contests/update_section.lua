local Usecase = require("http.Usecase")

---@class usecases.UpdateSection: http.Usecase
---@operator call: usecases.UpdateSection
local UpdateSection = Usecase + {}

function UpdateSection:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

function UpdateSection:handle(params)
	self.domain.sections:updateSection(params.session_user, params.contest_id, {
		name = params.name,
		time_base = tonumber(params.time_base) or 0,
		time_per_knote = tonumber(params.time_per_knote) or 0,
	})

	return "ok", params
end

return UpdateSection
