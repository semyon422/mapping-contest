local Users = require("models.users")
local preload = require("lapis.db.model").preload

local users_c = {}

function users_c.GET(self)
	local ctx = self.ctx

	ctx.users = Users:select()
	preload(ctx.users, "user_roles")

	return {render = true}
end

return users_c
