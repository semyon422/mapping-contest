local Page = require("web.page.Page")

---@class pages.User: web.Page
---@operator call: pages.User
local User = Page + {}

User.view = {layout = "user"}

function User:canChangeRole(user, role)
	return self.domain.auth:canChangeRole(self.user, user, role)
end

function User:canUpdateUser()
	return self.domain.users:canUpdateUser(self.user, self.params.user)
end

function User:canLoginAs()
	return self.domain.auth:canLoginAs(self.user)
end

return User
