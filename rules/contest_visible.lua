local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:condition(params)
	return params.contest.is_visible
end

return rule
