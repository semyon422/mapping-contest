local Usecase = require("usecases.Usecase")

local delete_contest = Usecase()

delete_contest:setPolicySet({{"contest_host"}})

delete_contest:bindModel("contests", {id = "contest_id"})

delete_contest:setHandler(function(params, models)
	params.contest:delete()
	return "deleted", params
end)

return delete_contest
