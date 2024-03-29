local Page = require("http.Page")

---@class pages.Users: http.Page
---@operator call: pages.Users
local Users = Page + {}

Users.view = {layout = "users"}

return Users
