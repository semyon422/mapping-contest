local relations = require("rdb.relations")
local autoload = require("autoload")

local Router = require("http.Router")
local UsecaseViewHandler = require("http.UsecaseViewHandler")
local SessionHandler = require("http.SessionHandler")
local RequestHandler = require("http.RequestHandler")

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

local session_handler = SessionHandler(session_config)
local uv_handler = UsecaseViewHandler(usecases, models, default_results, views)
local router = Router()

router:route_many(require("routes"))

local function before(params)
	if not params.session.user_id then
		return
	end

	local user = models.users:select({id = params.session.user_id})[1]
	if not user then
		return
	end

	relations.preload({user}, "user_roles")
	params.session_user = user
end

local body_handlers = autoload("body")

local requestHandler = RequestHandler(router, body_handlers, session_handler, uv_handler, before)

return function()
	local req = {}

	req.headers = ngx.req.get_headers()
	req.method = ngx.req.get_method()
	req.uri = ngx.var.request_uri

	local ok, code, headers, body = xpcall(requestHandler.handle, debug.traceback, requestHandler, req)
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
