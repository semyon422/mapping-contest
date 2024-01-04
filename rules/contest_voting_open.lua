local rule = {}

function rule:condition(params)
	return params.contest.is_voting_open
end

return rule
