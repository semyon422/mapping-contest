local Rule = require("abac.Rule")

local rule = Rule("permit")

function rule:condition()
	return true
end

return rule
