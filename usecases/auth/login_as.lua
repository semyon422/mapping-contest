local login_as = {}

login_as.policy_set = {{"role_admin"}}

function login_as.handler(params, models)
	params.session.user_id = tonumber(params.user_id)

	return "ok", params
end

return login_as
