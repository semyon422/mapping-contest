local Page = require("http.Page")

---@class pages.Login: http.Page
---@operator call: pages.Login
local Login = Page + {}

Login.view = {layout = "login"}

return Login
