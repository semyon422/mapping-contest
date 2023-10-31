local Usecase = require("usecases.Usecase")

local ping = Usecase()

ping:setPolicySet({{"permit"}})

function ping:run(params)
	return "ok", params
end

return ping
