local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:condition(request)
	return request.ctx.contest.is_voting_open
end

return rule
