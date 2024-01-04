local rule = {}

function rule:condition(params)
	local user = params.session_user
	return user and user.id ~= params.chart.charter_id
end

return rule
