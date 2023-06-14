package.path = "./?/init.lua;" .. package.path

local lapis = require("lapis")
local respond_to = require("lapis.application").respond_to
local app = lapis.Application()
local access = require("access")
local db = require("lapis.db")
local rules = require("rules")
local paraltable = require("paraltable")
local capture_errors = require("lapis.application").capture_errors

-- require("etlua_patch")
db.query("PRAGMA foreign_keys = ON;")
local struct = require("struct")
struct:define_models()

local load_session_user = require("context_loaders.session_user")

app:enable("etlua")
app.layout = require("views.layout")

local resources = {}

local function eval_rule(self, name, ...)
	local request = ... and paraltable(..., self) or self
	return rules[name]:evaluate(request) == "permit"
end

local function eval_policy(self, name, ...)
	local request = ... and paraltable(..., self) or self
	return access:get(name):evaluate_rules(request) == "permit"
end

app:before_filter(function(self)
	self.ctx = {}
	self.models = require("models")
	self.util = require("util")
	self.rule = eval_rule
	self.policy = eval_policy
	self.request = self
	local resource = resources[self.route_name]

	self.ctx.ip = self.req.headers["X-Real-IP"]

	load_session_user(self)

	local found = true
	if resource then
		for _, n in ipairs(resource.loaders) do
			local loader = require("loaders." .. n)
			local v = loader(self.params, self.ctx)
			found = found and v
		end
	end
	if not found and self.req.method == "GET" then
		return self:write({render = "not_found", status = 404})
	end

	local decision, err = access:evaluate(self)
	if decision ~= "permit" then
		self:write({err or "Forbidden", status = 403})
	end
end)

for _, endpoint in ipairs(require("endpoints")) do
	local c = require("controllers." .. endpoint[1])

	local respond = capture_errors(respond_to(c))
	app:match(endpoint[1], endpoint[2], respond)
end

for _, res in ipairs(struct:get_resources()) do
	local mod = "controllers." .. res.controller
	local respond
	if package.searchpath(mod, package.path) then
		local c = require(mod)
		resources[res.route_name] = res
		respond = capture_errors({respond_to(c), on_error = function(self)
			return {render = "errors", layout = false}
		end})
	end
	app:match(res.route_name, res.path, respond or function(self)
		return "Not implemented"
	end)
end

return app
