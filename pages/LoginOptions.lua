local Page = require("web.page.Page")

---@class pages.LoginOptions: web.Page
---@operator call: pages.LoginOptions
local LoginOptions = Page + {}

LoginOptions.view = {layout = "login_options"}

return LoginOptions
