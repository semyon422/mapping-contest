local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:target(params)
	return params.contest.is_submission_open
end

return rule
