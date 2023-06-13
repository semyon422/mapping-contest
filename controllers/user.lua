local Users = require("models.users")
local preload = require("lapis.db.model").preload

local user_c = {}

function user_c.GET(self)
	local ctx = self.ctx

	ctx.user = Users:find(self.params.user_id)
	preload({ctx.user}, "user_roles")

	return {render = true}
end

return user_c
