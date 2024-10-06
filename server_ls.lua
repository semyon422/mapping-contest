local pkg_config = require("pkg_config")

local socket = require("socket")
local LuasocketServer = require("web.socket.LuasocketServer")

package.loaded.utf8 = require("lua-utf8")

local etlua_util = require("web.page.etlua_util")
local App = require("app.App")

local app = App()
app:load()

table.insert(package.loaders, etlua_util.loader)

local server = LuasocketServer("*", 8180, app.webApp)

server:load()

while true do
	server:update()
	socket.sleep(0.1)
end
