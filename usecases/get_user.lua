local relations = require("rdb.relations")
local Usecase = require("usecases.Usecase")

local get_user = Usecase()

get_user:bindModel("users", {id = "user_id"})

get_user:setHandler(function(params, models)
	relations.preload({params.user}, "user_roles")
	return "ok", params
end)

return get_user
