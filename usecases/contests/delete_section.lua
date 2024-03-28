local Usecase = require("http.Usecase")

---@class usecases.DeleteSection: http.Usecase
---@operator call: usecases.DeleteSection
local DeleteSection = Usecase + {}

function DeleteSection:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

DeleteSection.models = {
	contest = {"contests", {id = "contest_id"}},
	section = {"sections", {id = "section_id"}},
}

function DeleteSection:handle(params)
	params.section:delete()

	return "deleted", params
end

return DeleteSection
