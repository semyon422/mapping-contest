local Page = require("http.Page")

---@class pages.User: http.Page
---@operator call: pages.User
local User = Page + {}

User.view = {layout = "user"}

function User:canChangeRole(role)
	return self.domain.auth:canChangeRole(self.user, role)
end

function User:canUpdateUser()
	return self.domain.users:canUpdateUser(self.user, self.params.user)
end

function User:canLoginAs()
	return self.domain.auth:canLoginAs(self.user)
end

return User
