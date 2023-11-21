local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:condition(params)
	local user = params.session_user
	return user.id == params.chart.contest.host_id
end

return rule
