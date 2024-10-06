local Page = require("web.page.Page")

---@class pages.Register: web.Page
---@operator call: pages.Register
local Register = Page + {}

Register.view = {layout = "register"}

return Register
