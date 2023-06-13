local enum = require("lapis.db.model").enum

local Roles = enum({
	admin = 0,
	moderator = 1,
	host = 2,
	verified = 3,
})

Roles.list = {
	"admin",
	"moderator",
	"host",
	"verified",
}

Roles.below = {
	admin = {"moderator", "host"},
	moderator = {"verified"},
}

Roles.above = {}
for role, list in pairs(Roles.below) do
	for _, _role in ipairs(list) do
		Roles.above[_role] = Roles.above[_role] or {}
		table.insert(Roles.above[_role], role)
	end
end

-- is a -> b
function Roles:belongs(direction, a, b)
	local list = self[direction][a]
	if not list then return end
	for _, role in ipairs(list) do
		if role == b or Roles:belongs(direction, role, b) then
			return true
		end
	end
end

assert(Roles:belongs("below", "admin", "verified"))
assert(Roles:belongs("above", "verified", "admin"))

return Roles
