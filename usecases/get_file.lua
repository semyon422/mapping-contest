local Usecase = require("http.Usecase")

---@class usecases.GetFile: http.Usecase
---@operator call: usecases.GetFile
local GetFile = Usecase + {}

function GetFile:handle(params)
	local path = "storages/" .. params.file.hash
	local f = assert(io.open(path, "rb"))
	params.content = f:read("*a")
	f:close()
	return "ok"
end

return GetFile
