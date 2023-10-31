local Usecase = require("usecases.Usecase")

local delete_chart = Usecase()

function delete_chart:run(params, models)
	return "ok", params
end

return delete_chart
