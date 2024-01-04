local rule = {}

function rule:condition(params)
	return params.contest.is_visible
end

return rule
