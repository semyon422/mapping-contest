local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:condition(params)
	return params.session_user.id == params.contest.host_id
end

return rule
