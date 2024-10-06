local Page = require("web.page.Page")

---@class pages.Errors: web.Page
---@operator call: pages.Errors
local Errors = Page + {}

Errors.view = {layout = "errors"}

return Errors
