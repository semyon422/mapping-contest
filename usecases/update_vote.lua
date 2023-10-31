local Usecase = require("usecases.Usecase")

local update_vote = Usecase()

function update_vote:run(params, models)
	return "ok", params
end

return update_vote
