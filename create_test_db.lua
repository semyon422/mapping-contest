require("pkg_config")
package.loaded.utf8 = require("lua-utf8")

local App = require("app.App")

local app = App()
app:load()
app:createTestDatabase()
