local Usecase = require("usecases.Usecase")

local submit_track = Usecase()

submit_track:setHandler(function(params, models)
	return "ok", params
end)

return submit_track
