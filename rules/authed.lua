local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:target(params)
	return params.session.user_id
end

return rule
