local relations = require("rdb.relations")
local Usecase = require("usecases.Usecase")

local update_user = Usecase()

update_user:setPolicySet({{"role_admin"}})

update_user:bindModel("users", {id = "user_id"})

update_user:setHandler(function(params, usersRepo)
	relations.preload({params.user}, "user_roles")
	return "ok", params
end)

return update_user
