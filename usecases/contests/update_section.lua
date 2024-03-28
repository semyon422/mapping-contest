local Usecase = require("http.Usecase")

---@class usecases.UpdateSection: http.Usecase
---@operator call: usecases.UpdateSection
local UpdateSection = Usecase + {}

function UpdateSection:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

UpdateSection.models = {
	contest = {"contests", {id = "contest_id"}},
	section = {"sections", {id = "section_id"}},
}

UpdateSection.validate = {
	name = {"*", "string", {"#", 1, 128}},
	time_base = "number",
	time_per_knote = "number",
}

function UpdateSection:handle(params)
	params.section:update({
		name = params.name,
		time_base = tonumber(params.time_base) or 0,
		time_per_knote = tonumber(params.time_per_knote) or 0,
	})

	return "ok", params
end

return UpdateSection
