local remove_role = {}

remove_role.access = {{"change_role"}}

remove_role.models = {user_role = {"user_roles", {"user_id", "role"}}}

function remove_role.handle(params, models)
	params.user_role:delete()
	return "ok", params
end

return remove_role
