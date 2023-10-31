local Usecase = require("usecases.Usecase")

local update_contest = Usecase()

function update_contest:run(params, models)
	return "ok", params
end

return update_contest
