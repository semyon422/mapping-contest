local rule = {}

function rule:condition(params)
	local user = params.session_user
	return user.id == params.chart.charter_id
end

return rule
