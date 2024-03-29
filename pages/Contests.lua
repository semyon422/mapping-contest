local Page = require("http.Page")

---@class pages.Contests: http.Page
---@operator call: pages.Contests
local Contests = Page + {}

Contests.view = {layout = "contests"}

return Contests
