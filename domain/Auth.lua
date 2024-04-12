local class = require("class")
local bcrypt = require("bcrypt")

---@class domain.Auth
---@operator call: domain.Auth
local Auth = class()

---@param usersRepo domain.IUsersRepo
---@param userRolesRepo domain.IUserRolesRepo
---@param roles domain.Roles
---@param osuApiFactory domain.IOsuApiFactory
function Auth:new(usersRepo, userRolesRepo, roles, osuApiFactory)
	self.usersRepo = usersRepo
	self.userRolesRepo = userRolesRepo
	self.roles = roles
	self.osuApiFactory = osuApiFactory
end

function Auth:isLoggedIn(user)
	return user ~= nil
end

function Auth:canChangeRole(user, role)
	for _, user_role in ipairs(user.user_roles) do
		if self.roles:belongs("below", user_role.role, role) then
			return true
		end
	end
end

function Auth:canLoginAs(user)
	return self.roles:hasRole(user, "admin")
end

local failed = "Login failed. Invalid username or password"

function Auth:login(name, password)
	if not name or not password then
		return nil, failed
	end

	local user = self.usersRepo:findByName(name)
	if not user then
		return nil, failed
	end

	local valid = bcrypt.verify(password, user.password)
	if not valid then
		return nil, failed
	end
	return user
end

function Auth:register(name, password, discord)
	local user = self.usersRepo:findByName(name)
	if user then
		return nil, "This name is already taken"
	end

	local time = os.time()
	user = self.usersRepo:create({
		osu_id = 0,
		name = name,
		discord = discord,
		password = bcrypt.digest(password, 10),
		latest_activity = time,
		created_at = time,
	})

	return user
end

function Auth:oauth(code)
	local osuApi = self.osuApiFactory:getOsuApi()
	local ok, err = osuApi:oauth(code)
	if not ok then
		return nil, err
	end

	local me, err = osuApi:me()
	if not me then
		return nil, err
	end

	local user = self.usersRepo:findByOsuId(me.id)
	if user then
		user:update({
			name = me.username,
			discord = tostring(me.discord) or "",
		})
		return user
	end

	local time = os.time()
	user = self.usersRepo:create({
		osu_id = me.id,
		name = me.username,
		discord = tostring(me.discord) or "",
		password = "",
		latest_activity = time,
		created_at = time,
	})

	self.userRolesRepo:create({
		user_id = user.id,
		role = "verified",
	})

	return user
end

return Auth
