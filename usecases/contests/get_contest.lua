local relations = require("rdb.relations")
local voting = require("domain.voting")
local Errors = require("domain.Errors")

local get_contest = {}

function get_contest:handle(params)
	local contest, err = self.domain.contests:getContest(params.session_user, params.contest_id)
	if not contest then
		if err == Errors.not_found then
			return "not_found", params
		end
		error("unknown error")
	end

	relations.preload({contest}, {
		"host",
		"sections",
		"contest_users",
		user_contest_chart_votes = "user",
		contest_tracks = "track",
		charts = {"track", "charter"},
	})

	params.contest = contest
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
