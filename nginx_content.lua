local class = require("class")
local autoload = require("autoload")

local Router = require("http.Router")
local UsecaseViewHandler = require("http.UsecaseViewHandler")
local RequestParamsHandler = require("http.RequestParamsHandler")

local usecases = autoload("usecases")
local views = require("views")

local usecase_repos = {
	get_user = {},
	ok = {},
}

local default_results = {
	forbidden = {403, "json"},
	not_found = {404, "json"},
}
local session_config = {
	name = "session",
	secret = "secret string",
}

local uv_handler = UsecaseViewHandler(usecases, usecase_repos, default_results, views)
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

	local code, headers, body = router:handle_request(req)
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
