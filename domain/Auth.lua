local class = require("class")
local bcrypt = require("bcrypt")
local http = require("lapis.nginx.http")
local lapis_util = require("lapis.util")

---@class domain.Auth
---@operator call: domain.Auth
local Auth = class()

---@param usersRepo domain.IUsersRepo
---@param userRolesRepo domain.IUserRolesRepo
---@param roles domain.Roles
function Auth:new(usersRepo, userRolesRepo, roles)
	self.usersRepo = usersRepo
	self.userRolesRepo = userRolesRepo
	self.roles = roles
end

function Auth:isLoggedIn(user)
	return user ~= nil
end

function Auth:canChangeRole(role, target_user)
	for _, user_role in ipairs(target_user.user_roles) do
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

	local user = self.usersRepo:getByName(name)
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
	local user = self.usersRepo:getByName(name)
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

function Auth:oauth(osu_oauth, code)
	local body, status_code = http.simple("https://osu.ppy.sh/oauth/token", {
		client_id = osu_oauth.client_id,
		client_secret = osu_oauth.client_secret,
		code = code,
		grant_type = "authorization_code",
		redirect_uri = osu_oauth.redirect_uri,
	})

	if status_code ~= 200 then
		return nil, body
	end

	local res = lapis_util.from_json(body)

	body, status_code = http.simple({
		url = "https://osu.ppy.sh/api/v2/me",
		method = "GET",
		headers = {["Authorization"] = "Bearer " .. res.access_token}
	})

	if status_code ~= 200 then
		return nil, body
	end

	local me = lapis_util.from_json(body)

	local user = self.usersRepo:getByOsuId(me.id)
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
end

return Auth
