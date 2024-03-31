local class = require("class")
local enum = require("util.enum")

---@class domain.Roles
---@operator call: domain.Roles
local Roles = class()

---@param userRolesRepo domain.IUserRolesRepo
function Roles:new(userRolesRepo)
	self.userRolesRepo = userRolesRepo
end

Roles.enum = enum({
	admin = 0,
	moderator = 1,
	host = 2,
	verified = 3,
})

Roles.list = {  -- see enums.roles
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

function Roles:hasRole(user, role)
	for _, user_role in ipairs(user.user_roles) do
		local _role = user_role.role
		if _role == role or Roles:belongs("below", _role, role) then
			return true
		end
	end
end

function Roles:give(user_id, role)
	self.userRolesRepo:give(user_id, role)
end

function Roles:take(user_id, role)
	self.userRolesRepo:take(user_id, role)
end

return Roles
