local class = require("class")

---@class domain.Charts
---@operator call: domain.Charts
local Charts = class()

function Charts:canDelete(user, chart)
	-- {"is_submission_open", "chart_owner"},
	-- {"chart_contest_host"},
end

return Charts
