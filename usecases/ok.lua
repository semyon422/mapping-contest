local Usecase = require("http.Usecase")

---@class usecases.Ok: http.Usecase
---@operator call: usecases.Ok
local Ok = Usecase + {}

function Ok:handle(params)
	return "ok", params
end

return Ok
