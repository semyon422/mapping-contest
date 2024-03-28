local class = require("class")
local bcrypt = require("bcrypt")

---@class domain.Auth
---@operator call: domain.Auth
local Auth = class()

---@param usersRepo domain.IUsersRepo
function Auth:new(usersRepo)
	self.usersRepo = assert(usersRepo)
end

function Auth:isLoggedIn(user)
	return user ~= nil
end

function Auth:canChangeRole(user, target_user)

end

function Auth:canLoginAs(user, target_user)
	-- {{"role_admin"}}
end

local failed = "Login failed. Invalid username or password"

function Auth:login(name, password)
	if not name or not password then return false, failed end
	local user = self.usersRepo:getByName(name)
	if not user then return nil, failed end
	local valid = bcrypt.verify(password, user.password)
	if not valid then return nil, failed end
	return user
end

return Auth
