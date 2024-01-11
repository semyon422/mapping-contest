local bcrypt = require("bcrypt")

local update_user = {}

update_user.access = {{"role_admin"}}

update_user.models = {user = {"users", {id = "user_id"}}}

update_user.validate = {
	osu_id = "integer",
	name = {"*", "string", {"#", 1, 64}},
	discord = {"*", "string", {"#", 1, 64}},
	password = {"*", "string", {"#", 0, 64}},
}

function update_user:handle(params)
	local _user = self.models.users:find({name = params.name})
	if _user and _user.id ~= params.user.id then
		params.errors = {"This name is already taken"}
		return "validation", params
	end

	params.user:update({
		osu_id = params.osu_id,
		name = params.name,
		discord = params.discord,
	})

	if #params.password > 0 then
		params.user:update({
			password = bcrypt.digest(params.password, 10)
		})
	end

	return "ok", params
end

return update_user
