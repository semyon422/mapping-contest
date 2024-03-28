local File = require("domain.File")
local Usecase = require("http.Usecase")

---@class usecases.GetFile: http.Usecase
---@operator call: usecases.GetFile
local GetFile = Usecase + {}

GetFile.models = {file = {"files", {id = "file_id"}}}

function GetFile:handle(params)
	local file = File(params.file.hash)
	params.content = file:read()
	return "ok", params
end

return GetFile
