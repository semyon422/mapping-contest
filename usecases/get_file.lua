local File = require("domain.File")
local Usecase = require("http.Usecase")

---@class usecases.GetFile: http.Usecase
---@operator call: usecases.GetFile
local GetFile = Usecase + {}

function GetFile:handle(params)
	local file = File(params.file.hash)
	params.content = file:read()
	return "ok"
end

return GetFile
