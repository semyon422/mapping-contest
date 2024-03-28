local Usecase = require("http.Usecase")

---@class usecases.GetContests: http.Usecase
---@operator call: usecases.GetContests
local GetContests = Usecase + {}

function GetContests:handle(params)
	params.contests = self.domain.contests:getContests()
	return "ok", params
end

return GetContests
