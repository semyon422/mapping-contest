local rules = require("rules")
local usecases = require("usecases")

local access_helper = {}

function access_helper.rule(name, params)
	return rules[name]:evaluate(params) == "permit"
end

function access_helper.authorize(usecase_name, params)
	return usecases[usecase_name]:authorize(params) == "permit"
end

return access_helper
