local WebApp = require("http.WebApp")
local etlua_util = require("http.etlua_util")

local config = require("lapis.config").get()

local webApp = WebApp(config)

table.insert(package.loaders, etlua_util.loader)

return function()
	local req = {}

	req.headers = ngx.req.get_headers()
	req.method = ngx.req.get_method()
	req.uri = ngx.var.request_uri

	local ok, code, headers, body = webApp:handle(req)
	if not ok then
		ngx.status = 500
		ngx.print("<pre>" .. tostring(code) .. "</pre>")
		return
	end

	if not code then
		ngx.status = 404
		return
	end

	ngx.status = code
	for k, v in pairs(headers) do
		ngx.header[k] = v
	end
	ngx.print(body)
end
