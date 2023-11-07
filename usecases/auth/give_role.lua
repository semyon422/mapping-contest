local give_role = {}

give_role.policy_set = {{"change_role"}}

give_role.models = {user = {"users", {id = "user_id"}}}

function give_role.handler(params, models)
	models.user_roles:insert({
		user_id = params.user_id,
		role = params.role,
	})
	return "ok", params
end

return give_role
