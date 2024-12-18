local Page = require("web.framework.page.Page")

---@class pages.Login: web.Page
---@operator call: pages.Login
local Login = Page + {}

Login.view = {layout = "login"}

return Login
