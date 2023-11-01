local Usecase = require("usecases.Usecase")
local bcrypt = require("bcrypt")

local update_user = Usecase()

update_user:setPolicySet({{"role_admin"}})

update_user:bindModel("users", {id = "user_id"})

update_user:setHandler(function(params, models)
	local _user = models.users:select({name = params.name})[1]
	if _user and _user.id ~= params.user.id then
		params.errors = {"This name is already taken"}
		return "validation", params
	end

	params.user:update({
		osu_id = params.osu_id,
		name = params.name,
		discord = params.discord,
	})

	if params.password then
		params.user:update({
			password = bcrypt.digest(params.password, 10)
		})
	end

	return "ok", params
end)

return update_user
