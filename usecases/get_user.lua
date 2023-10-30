return function(params, usersRepo)
	-- validate
	-- authorize
	params.session.id = params.user_id
	return "ok", {
		message = "hi",
		params = params,
	}
end
