local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:condition(params)
	return params.session_user.id == params.chart.contest.host_id
end

return rule
