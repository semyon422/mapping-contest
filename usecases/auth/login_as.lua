local login_as = {}

login_as.access = {{"role_admin"}}

login_as.validate = {
	user_id = "integer",
}

function login_as:handle(params)
	params.session.user_id = params.user_id

	return "ok", params
end

return login_as
