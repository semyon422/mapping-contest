local Usecase = require("usecases.Usecase")

local give_role = Usecase()

give_role:setPolicySet({{"change_role"}})

give_role:bindModel("users", {id = "user_id"})

give_role:setHandler(function(params, models)
	models.user_roles:insert({
		user_id = params.user_id,
		role = params.role,
	})
	return "ok", params
end)

return give_role
