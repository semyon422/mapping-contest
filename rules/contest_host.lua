local rule = {}

function rule:condition(params)
	local user = params.session_user
	return user and user.id == params.contest.host_id
end

return rule
