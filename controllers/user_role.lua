local User_roles = require("models.user_roles")
local Roles = require("enums.roles")

local user_role_c = {}

function user_role_c.PUT(self)
	local params = self.params

	local user_role = User_roles:create({
		user_id = params.user_id,
		role = Roles:for_db(params.role),
	})

	return {status = 201}
end

function user_role_c.DELETE(self)
	local params = self.params

	local user_role = User_roles:find({
		user_id = params.user_id,
		role = Roles:for_db(params.role),
	})
	user_role:delete()

	return {status = 204}
end

return user_role_c
