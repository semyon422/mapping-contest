local Usecase = require("usecases.Usecase")

local get_contests = Usecase()

get_contests:setHandler(function(params, models)
	params.contests = models.contests:select()
	return "ok", params
end)

return get_contests
