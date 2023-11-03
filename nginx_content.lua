local class = require("class")

local Router = require("http.Router")
local UsecaseViewHandler = require("http.UsecaseViewHandler")
local RequestParamsHandler = require("http.RequestParamsHandler")

local Usecases = require("http.Usecases")
local usecases = Usecases("usecases")

local views = require("views")

local Models = require("rdb.Models")
local TableOrm = require("rdb.TableOrm")
local LsqliteDatabase = require("rdb.LsqliteDatabase")

local db = LsqliteDatabase()
db:open("db.sqlite")
db:query("PRAGMA foreign_keys = ON;")

local models = Models("models", TableOrm(db))

local default_results = {
	forbidden = {403, "json", {["Content-Type"] = "application/json"}},
	not_found = {404, "json", {["Content-Type"] = "application/json"}},
}
local session_config = {
	name = "session",
	secret = "secret string",
}

local uv_handler = UsecaseViewHandler(usecases, models, default_results, views)
local rp_handler = RequestParamsHandler(session_config, uv_handler)
local router = Router(rp_handler)

router:route_many(require("routes"))

local Request = class()

function Request:new(body)
	self.body = body
end

function Request:receive()
	return self.body
end

return function()
	ngx.req.read_body()
	local data = ngx.req.get_body_data()
	local req = Request(data)

	req.headers = ngx.req.get_headers()
	req.method = ngx.req.get_method()
	req.uri = ngx.var.request_uri

	local ok, code, headers, body = xpcall(router.handle_request, debug.traceback, router, req)
	if not ok then
		ngx.status = 500
		ngx.print("<pre>" .. code .. "</pre>")
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
