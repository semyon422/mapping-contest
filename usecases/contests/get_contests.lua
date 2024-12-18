local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.GetContests: web.Usecase
---@operator call: usecases.GetContests
local GetContests = Usecase + {}

function GetContests:handle(params)
	params.contests = self.domain.contests:getContests()
	return "ok"
end

return GetContests
