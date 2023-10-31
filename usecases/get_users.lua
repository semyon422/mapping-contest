local relations = require("rdb.relations")
local Usecase = require("usecases.Usecase")

local get_users = Usecase()

function get_users:run(params, models)
	params.users = models.users:select()
	relations.preload(params.users, "user_roles")
	return "ok", params
end

return get_users