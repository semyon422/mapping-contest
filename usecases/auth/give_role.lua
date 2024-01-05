local give_role = {}

give_role.access = {{"change_role"}}

give_role.models = {user = {"users", {id = "user_id"}}}

function give_role:handle(params)
	self.models.user_roles:create({
		user_id = params.user_id,
		role = params.role,
	})
	return "ok", params
end

return give_role
