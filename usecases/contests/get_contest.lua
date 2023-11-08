local relations = require("rdb.relations")

local get_contest = {}

get_contest.policy_set = {
	{"contest_visible"},
	{"contest_host"},
}

get_contest.models = {contest = {"contests", {id = "contest_id"}}}

function get_contest.handler(params, models)
	relations.preload({params.contest}, {
		"host",
		contest_tracks = "track",
		charts = {"track", "charter"}
	})

	return "ok", params
end

return get_contest
