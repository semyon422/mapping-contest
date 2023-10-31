local Usecase = require("usecases.Usecase")

local submit_chart = Usecase()

function submit_chart:run(params, models)
	return "ok", params
end

return submit_chart
