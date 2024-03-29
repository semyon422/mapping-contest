local bcrypt = require("bcrypt")
local Usecase = require("http.Usecase")

---@class usecases.UpdateUser: http.Usecase
---@operator call: usecases.UpdateUser
local UpdateUser = Usecase + {}

UpdateUser.validate = {
	osu_id = "integer",
	name = {"*", "string", {"#", 1, 64}},
	discord = {"*", "string", {"#", 1, 64}},
	password = {"*", "string", {"#", 0, 64}},
}

function UpdateUser:handle(params)
	local user, err = self.domain.users:updateUser({
		user_id = params.user_id,
		osu_id = params.osu_id,
		name = params.name,
		discord = params.discord,
		password = params.password,
	})
	assert(user)
	params.user = user

	return "ok"
end

return UpdateUser
