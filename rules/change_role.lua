local Rule = require("abac.Rule")
local Roles = require("domain.Roles")

local rule = Rule("permit")

function rule:condition(params)
	local user = params.session_user
	if not user then
		return
	end
	local role = params.role
	for _, user_role in ipairs(user.user_roles) do
		if Roles:belongs("below", user_role.role, role) then
			return true
		end
	end
end

return rule
