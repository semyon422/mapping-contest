local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:condition(params)
	return params.contest.is_voting_open
end

return rule
