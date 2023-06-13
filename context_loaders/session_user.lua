local Users = require("models.users")
local Roles = require("enums.roles")

return function(self)
	local ctx = self.ctx
	ctx.roles = {}

	if not self.session.user_id then
		return
	end

	local user = Users:find(self.session.user_id)
	if not user then
		return
	end

	user:get_user_roles()
	self.ctx.session_user = user
end
