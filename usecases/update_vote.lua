local Usecase = require("usecases.Usecase")

local update_vote = Usecase()

update_vote:setHandler(function(params, models)
	return "ok", params
end)

return update_vote
