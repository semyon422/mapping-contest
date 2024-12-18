local app = require("app")

local NginxRequest = require("web.nginx.NginxRequest")
local NginxReqSocket = require("web.nginx.NginxReqSocket")
local Response = require("web.http.Response")

return function()
	local soc = NginxReqSocket()
	local req = NginxRequest(soc)
	local res = Response(soc)
	app.webApp:handle(req, res, {})
end
