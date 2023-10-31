local relations = require("rdb.relations")
local Usecase = require("usecases.Usecase")

local update_user = Usecase()

update_user:setPolicySet({{"role_admin"}})

function update_user:run(params, usersRepo)
	params.user = usersRepo:select({id = tonumber(params.user_id)})[1]
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

return update_user
