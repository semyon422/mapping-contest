local Usecase = require("http.Usecase")

---@class usecases.DeleteSection: http.Usecase
---@operator call: usecases.DeleteSection
local DeleteSection = Usecase + {}

function DeleteSection:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

function DeleteSection:handle(params)
	self.domain.sections:deleteSections(params.section_id)
	return "deleted", params
end

return DeleteSection
