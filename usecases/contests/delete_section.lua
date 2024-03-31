local Usecase = require("http.Usecase")

---@class usecases.DeleteSection: http.Usecase
---@operator call: usecases.DeleteSection
local DeleteSection = Usecase + {}

function DeleteSection:handle(params)
	self.domain.sections:deleteSection(params.session_user, params.section_id)
	return "deleted"
end

return DeleteSection
