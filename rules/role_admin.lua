local Rule = require("abac.Rule")
local has_role = require("domain.has_role")

local rule = Rule("permit")

function rule:target(params)
	local user = params.session_user
	return user and has_role(user, "admin")
end

return rule
