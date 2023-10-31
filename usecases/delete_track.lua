local Usecase = require("usecases.Usecase")

local delete_track = Usecase()

function delete_track:run(params, models)
	return "ok", params
end

return delete_track
