local rule = {}

function rule:condition(params)
	local user = params.session_user
	return user.id == params.chart.contest.host_id
end

return rule
