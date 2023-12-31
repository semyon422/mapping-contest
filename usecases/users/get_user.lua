local relations = require("rdb.relations")

local get_user = {}

get_user.models = {user = {"users", {id = "user_id"}}}

function get_user:handle(params)
	relations.preload({params.user}, "user_roles")
	return "ok", params
end

return get_user
