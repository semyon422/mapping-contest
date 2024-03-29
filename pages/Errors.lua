local Page = require("http.Page")

---@class pages.Errors: http.Page
---@operator call: pages.Errors
local Errors = Page + {}

Errors.view = {layout = "errors"}

return Errors
