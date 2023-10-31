local Usecase = require("usecases.Usecase")

local ok = Usecase()

function ok:run(params)
	return "ok", params
end

return ok
