local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:target(params)
	return params.session_user ~= nil
end

return rule
