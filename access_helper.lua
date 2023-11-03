local rules = require("rules")
local Usecase = require("http.Usecase")

local access_helper = {}

function access_helper.rule(name, params)
	return rules[name]:evaluate(params) == "permit"
end

function access_helper.authorize(usecase_name, params)
	local usecase = require("usecases." .. usecase_name)
	local policy_set = usecase.policy_set

	local uc = Usecase()
	if policy_set then
		uc:setPolicySet(policy_set)
	end

	return uc:authorize(params) == "permit"
end

return access_helper
