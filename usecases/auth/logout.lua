local logout = {}

logout.access = {{"authed"}}

function logout:handle(params)
	params.session.user_id = nil
	return "ok", params
end

return logout
