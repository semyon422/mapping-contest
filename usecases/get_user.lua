local relations = require("rdb.relations")
local Usecase = require("usecases.Usecase")

local get_user = Usecase()

get_user:setPolicySet({{"permit"}})

function get_user:run(params, models)
	params.user = models.users:select({id = tonumber(params.user_id)})[1]
	if not params.user then
		return "not_found", params
	end

	local decision, err = self:authorize(params)
	if decision ~= "permit" then
		return "forbidden", {err}
	end

	relations.preload({params.user}, "user_roles")

	return "ok", params
end

return get_user
