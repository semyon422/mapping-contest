local Usecase = require("web.usecase.Usecase")

---@class usecases.CreateSection: web.Usecase
---@operator call: usecases.CreateSection
local CreateSection = Usecase + {}

function CreateSection:handle(params)
	local section, err = self.domain.sections:createSection(params.session_user, params.contest_id, {
		contest_id = params.contest_id,
		name = params.name,
		time_base = tonumber(params.time_base) or 0,
		time_per_knote = tonumber(params.time_per_knote) or 0,
	})
	assert(section)

	return "ok"
end

return CreateSection
