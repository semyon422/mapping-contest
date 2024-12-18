local Usecase = require("web.framework.usecase.Usecase")

---@class usecases.Ok: web.Usecase
---@operator call: usecases.Ok
local Ok = Usecase + {}

function Ok:handle(params)
	return "ok"
end

return Ok
