local has_role = require("domain.has_role")

local rule = {}

function rule:condition(params)
	local user = params.session_user
	return user and has_role(user, "admin")
end

return rule
