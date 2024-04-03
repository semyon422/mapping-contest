local Page = require("http.Page")

---@class pages.File: http.Page
---@operator call: pages.File
local File = Page + {}

File.view = "file"

return File
