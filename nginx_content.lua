package.loaded.utf8 = require("lua-utf8")

local etlua_util = require("http.etlua_util")
local NginxRequest = require("web.nginx.NginxRequest")
local NginxResponse = require("web.nginx.NginxResponse")
local App = require("app.App")

local app = App()
app:load()

table.insert(package.loaders, etlua_util.loader)

return function()
	local req = NginxRequest()
	local res = NginxResponse()
	app.webApp:handle(req, res)
end
