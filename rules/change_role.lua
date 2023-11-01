local Rule = require("abac.Rule")
local Roles = require("enums.roles")

local rule = Rule("permit")

function rule:condition(params)
	local role = params.role
	for _, user_role in ipairs(params.session_user.user_roles) do
		if Roles:belongs("below", user_role.role, role) then
			return true
		end
	end
end

return rule
