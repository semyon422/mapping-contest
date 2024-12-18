package.loaded.utf8 = require("lua-utf8")

local etlua_util = require("web.framework.page.etlua_util")
local App = require("app.App")

local app = App()
app:load()

table.insert(package.loaders, etlua_util.loader)

return app
