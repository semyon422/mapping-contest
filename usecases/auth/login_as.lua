local login_as = {}

login_as.access = {{"role_admin"}}

function login_as:handle(params)
	params.session.user_id = tonumber(params.user_id)

	return "ok", params
end

return login_as
