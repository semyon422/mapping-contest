local relations = require("rdb.relations")
local usecase_decorators = require("usecase_decorators")

local function get_users(params, usersRepo)
	params.users = usersRepo:select()
	relations.preload(params.users, "user_roles")
	return "ok", params
end

get_users = usecase_decorators.access(get_users, {{"permit"}})

return get_users
