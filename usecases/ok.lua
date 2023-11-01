local Usecase = require("usecases.Usecase")

local ok = Usecase()

ok:setHandler(function(params)
	return "ok", params
end)

return ok
