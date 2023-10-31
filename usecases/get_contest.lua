local Usecase = require("usecases.Usecase")
local relations = require("rdb.relations")

local get_contest = Usecase()

function get_contest:run(params, models)
	params.contest = models.contests:select({id = tonumber(params.contest_id)})[1]
	if not params.contest then
		return "not_found", params
	end

	relations.preload({params.contest}, {
		"host",
		contest_tracks = "track",
		charts = {"track", "charter"}
	})
	for _, chart in ipairs(params.contest.charts) do
		chart.contest = params.contest
	end

	return "ok", params
end

return get_contest
