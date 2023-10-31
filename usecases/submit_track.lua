local Usecase = require("usecases.Usecase")

local submit_track = Usecase()

function submit_track:run(params, models)
	return "ok", params
end

return submit_track
