local Page = require("web.framework.page.Page")

---@class pages.LoginOptions: web.Page
---@operator call: pages.LoginOptions
local LoginOptions = Page + {}

LoginOptions.view = {layout = "login_options"}

return LoginOptions
