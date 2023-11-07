local Roles = require("domain.Roles")

return function(user, role)
	for _, user_role in ipairs(user.user_roles) do
		local _role = user_role.role
		if _role == role or Roles:belongs("below", _role, role) then
			return true
		end
	end
end
