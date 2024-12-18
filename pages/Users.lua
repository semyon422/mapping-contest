local Page = require("web.framework.page.Page")

---@class pages.Users: web.Page
---@operator call: pages.Users
local Users = Page + {}

Users.view = {layout = "users"}

function Users:canChangeRole(user, role)
	return self.domain.auth:canChangeRole(self.user, user, role)
end

return Users
