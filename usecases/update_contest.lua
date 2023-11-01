local Usecase = require("usecases.Usecase")

local update_contest = Usecase()

update_contest:setHandler(function(params, models)
	return "ok", params
end)

return update_contest
