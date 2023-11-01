local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:target(params)
	local user = params.session_user
	return user and user:has_role("verified")
end

return rule
