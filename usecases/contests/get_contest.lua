local relations = require("rdb.relations")
local voting = require("domain.voting")

local get_contest = {}

get_contest.access = {
	{"contest_visible"},
	{"contest_host"},
}

get_contest.models = {contest = {"contests", {id = "contest_id"}}}

function get_contest:handle(params)
	relations.preload({params.contest}, {
		"host",
		"sections",
		"contest_users",
		user_contest_chart_votes = "user",
		contest_tracks = "track",
		charts = {"track", "charter"},
	})

	params.section_vote_charts = voting.load_sections(params)

	local user_id = params.session.user_id
	if user_id then
		for _, contest_user in ipairs(params.contest.contest_users) do
			if contest_user.user_id == user_id then
				params.contest_user = contest_user
				break
			end
		end
	end

	return "ok", params
end

return get_contest
