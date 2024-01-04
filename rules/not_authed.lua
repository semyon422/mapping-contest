local rule = {}

function rule:condition(params)
	return not params.session_user
end

return rule
