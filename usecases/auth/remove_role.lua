local Usecase = require("usecases.Usecase")

local remove_role = Usecase()

remove_role:setPolicySet({{"change_role"}})

remove_role:bindModel("user_roles", {"user_id", "role"})

remove_role:setHandler(function(params, models)
	params.user_role:delete()
	return "ok", params
end)

return remove_role
