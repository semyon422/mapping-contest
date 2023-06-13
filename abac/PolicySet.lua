local class = require("class")

local PolicySet, newPolicySet = class("abac.Policy")

PolicySet.combine = require("abac.combines.first_applicable")

return newPolicySet
