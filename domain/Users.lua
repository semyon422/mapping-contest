local class = require("class")
local bcrypt = require("bcrypt")

---@class domain.Users
---@operator call: domain.Users
local Users = class()

---@param usersRepo domain.IUsersRepo
---@param roles domain.Roles
function Users:new(usersRepo, roles)
	self.usersRepo = usersRepo
	self.roles = roles
end

function Users:canUpdateUser(user, target_user)
	return self.roles:hasRole(user, "admin")
end

---@param user_id number
---@return table?
function Users:getUser(user_id)
	return self.usersRepo:getById(user_id)
end

function Users:getUsers()
	return self.usersRepo:getAll()
end

---@param user_params table
function Users:updateUser(s_user, user_id, user_params)
	local user = self.usersRepo:getById(user_id)
	if not user then
		return
	end
	if not self:canUpdateUser(s_user, user) then
		return
	end

	local _user = self.usersRepo:getByName(user_params.name)
	if _user and _user.id ~= user.id then
		-- params.errors = {"This name is already taken"}
		return
	end

	user:update({
		osu_id = user_params.osu_id,
		name = user_params.name,
		discord = user_params.discord,
	})

	if #user_params.password > 0 then
		user:update({
			password = bcrypt.digest(user_params.password, 10)
		})
	end

	return user
end

return Users
