local Page = require("http.Page")

---@class pages.LoginOptions: http.Page
---@operator call: pages.LoginOptions
local LoginOptions = Page + {}

LoginOptions.view = {layout = "login_options"}

return LoginOptions
