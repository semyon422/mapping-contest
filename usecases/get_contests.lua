local Usecase = require("usecases.Usecase")

local get_contests = Usecase()

function get_contests:run(params, models)
	params.contests = models.contests:select()
	return "ok", params
end

return get_contests
