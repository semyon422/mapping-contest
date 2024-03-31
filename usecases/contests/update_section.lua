local Usecase = require("http.Usecase")

---@class usecases.UpdateSection: http.Usecase
---@operator call: usecases.UpdateSection
local UpdateSection = Usecase + {}

function UpdateSection:handle(params)
	self.domain.sections:updateSection(params.session_user, params.section_id, {
		name = params.name,
		time_base = tonumber(params.time_base) or 0,
		time_per_knote = tonumber(params.time_per_knote) or 0,
	})

	return "ok"
end

return UpdateSection
