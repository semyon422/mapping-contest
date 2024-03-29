local Page = require("http.Page")

---@class pages.User: http.Page
---@operator call: pages.User
local User = Page + {}

User.view = {layout = "user"}

return User
