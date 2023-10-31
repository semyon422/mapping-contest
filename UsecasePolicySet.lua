
local Policy = require("abac.Policy")
local PolicySet = require("abac.PolicySet")

local UsecasePolicy = Policy + {}

UsecasePolicy.require_prefix = "rules."

local UsecasePolicySet = PolicySet + {}

function UsecasePolicySet:append(policy_set)
	PolicySet.append(self, policy_set, UsecasePolicy)
end

return UsecasePolicySet
