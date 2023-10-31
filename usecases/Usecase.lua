local class = require("class")
local relations = require("rdb.relations")
local UsecasePolicySet = require("UsecasePolicySet")

local Usecase = class()

function Usecase:setPolicySet(policy_set)
	self.policy_set = UsecasePolicySet()
	self.policy_set:append(policy_set)
end

function Usecase:authorize(params)
	if not self.policy_set then
		return
	end
	return self.policy_set:evaluate(params)
end

function Usecase:run(params)
	return "ok", {}
end

return Usecase
