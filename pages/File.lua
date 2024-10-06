local Page = require("web.page.Page")

---@class pages.File: web.Page
---@operator call: pages.File
local File = Page + {}

File.view = "file"

return File
