local class = require("class")

local Policy = require("abac.Policy")
local PolicySet = require("abac.PolicySet")

local WebPolicy, newWebPolicy = class(Policy)

WebPolicy.require_prefix = "rules."

local WebPolicySet, newWebPolicySet = class(PolicySet)

function WebPolicySet:new(route_name, method)
	self.route_name = route_name
	self.method = method
end

function WebPolicySet:target(request)
	return request.route_name == self.route_name and request.req.method == self.method
end

local AppPolicySet, newAppPolicySet = class(PolicySet)

function AppPolicySet:new()
	self.policies_map = {}
end

function AppPolicySet:get(name)
	return self.policies_map[name]
end

function AppPolicySet:add(route_name, method, data)
	local set = newWebPolicySet(route_name, method)
	set:append(data, newWebPolicy)
	self.policies_map[route_name .. "." .. method] = set
	self:append({set})
end

local access = newAppPolicySet()

-- access:append({{{"permit"}}}, PolicySet, newWebPolicy)

access:add("home", "GET", {{"permit"}})

access:add("login", "GET", {{"not_authed"}})
access:add("login", "POST", {{"not_authed"}})

access:add("register", "GET", {{"not_authed"}})
access:add("register", "POST", {{"not_authed"}})

access:add("logout", "POST", {{"authed"}})

access:add("contests", "GET", {{"permit"}})
access:add("contests", "POST", {{"role_host"}})

access:add("contest", "GET", {
	{"contest_visible"},
	{"contest_host"}
})
access:add("contest", "PATCH", {{"contest_host"}})
access:add("contest", "DELETE", {{"contest_host"}})
access:add("contest.track", "DELETE", {{"contest_host"}})
access:add("contest.tracks", "POST", {{"contest_host"}})

access:add("contest.user_chart_votes", "GET", {
	{"contest_visible"},
	{"contest_host"}
})
access:add("contest.user_chart_votes", "PATCH", {{"role_verified", "contest_voting_open"}})

access:add("charts", "POST", {{"role_verified"}})

access:add("chart", "DELETE", {
	{"chart_owner"},
	{"chart_contest_host"},
})

access:add("users", "GET", {{"permit"}})

access:add("user", "GET", {{"permit"}})
access:add("user", "PATCH", {{"role_admin"}})

access:add("user.role", "PUT", {{"change_role"}})
access:add("user.role", "DELETE", {{"change_role"}})

access:add("file", "GET", {{"permit"}})

return access
