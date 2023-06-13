local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:target(request)
	local user = request.ctx.session_user
	return user and user:has_role("moderator")
end

return rule
