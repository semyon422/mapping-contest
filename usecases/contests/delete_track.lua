local Usecase = require("usecases.Usecase")

local delete_track = Usecase()

delete_track:setPolicySet({{"contest_host"}})

delete_track:setHandler(function(params, models)
	return "ok", params
end)

return delete_track
