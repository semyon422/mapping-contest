local Usecase = require("usecases.Usecase")
local relations = require("rdb.relations")

local get_contest = Usecase()

get_contest:bindModel("contests", {id = "contest_id"})

get_contest:setHandler(function(params, models)
	relations.preload({params.contest}, {
		"host",
		contest_tracks = "track",
		charts = {"track", "charter"}
	})
	for _, chart in ipairs(params.contest.charts) do
		chart.contest = params.contest
	end

	return "ok", params
end)

return get_contest
