local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:target(request)
	return request.session.user_id
end

return rule
