local relations = require("rdb.relations")

local get_users = {}

function get_users:handle(params)
	params.users = self.models.users:select()
	relations.preload(params.users, "user_roles")
	return "ok", params
end

return get_users
