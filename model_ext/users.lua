local Roles = require("domain.roles")

local User = {}

function User:has_role(role)
	for _, user_role in ipairs(self.user_roles) do
		local _role = user_role.role
		if _role == role or Roles:belongs("below", _role, role) then
			return true
		end
	end
end

return User
