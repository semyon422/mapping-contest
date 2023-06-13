local Rule = require("abac.Rule")
local Roles = require("enums.roles")

local rule = Rule("permit")

function rule:condition(request)
	local role = request.params.role
	for _, user_role in ipairs(request.ctx.session_user.user_roles) do
		if Roles:belongs("below", Roles:to_name(user_role.role), role) then
			return true
		end
	end
end

return rule
