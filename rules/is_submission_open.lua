local rule = {}

function rule:condition(params)
	return params.contest.is_submission_open
end

return rule
