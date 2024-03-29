local Page = require("http.Page")

---@class pages.Register: http.Page
---@operator call: pages.Register
local Register = Page + {}

Register.view = {layout = "register"}

return Register
