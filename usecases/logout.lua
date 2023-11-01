local Usecase = require("usecases.Usecase")

local logout = Usecase()

logout:setPolicySet({{"authed"}})

logout:setHandler(function(params)
	params.session.user_id = nil
	return "ok", params
end)

return logout
