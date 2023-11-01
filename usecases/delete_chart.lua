local Usecase = require("usecases.Usecase")

local delete_chart = Usecase()

delete_chart:bindModel("charts", {id = "chart_id"})

delete_chart:setHandler(function(params, models)
	params.chart:delete()
	return "deleted", params
end)

return delete_chart
