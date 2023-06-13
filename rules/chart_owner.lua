local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:condition(request)
	return request.session.user_id == request.ctx.chart.charter_id
end

return rule
