local Usecase = require("usecases.Usecase")
local relations = require("rdb.relations")
local Votes = require("domain.Votes")

local get_votes = Usecase()

local function new_vote_chart(chart)
	local vote_chart = {
		chart = chart,
		voted = {},
	}
	for _, vote in ipairs(Votes.list) do
		vote_chart[vote] = {}
	end
	return vote_chart
end

local function sort_vote_charts(a, b)
	return a.chart.id < b.chart.id
end

function get_votes:run(params, models)
	params.contest = models.contests:select({id = tonumber(params.contest_id)})[1]
	if not params.contest then
		return "not_found", params
	end

	relations.preload({params.contest}, {
		user_contest_chart_votes = "user",
		charts = {"track", "charter"}
	})

	local vote_charts_map = {}
	for _, chart in ipairs(params.contest.charts) do
		vote_charts_map[chart.id] = new_vote_chart(chart)
	end

	for _, uccv in ipairs(params.contest.user_contest_chart_votes) do
		local vote_chart = vote_charts_map[uccv.chart_id]

		local vote = uccv.vote
		table.insert(vote_chart[vote], uccv.user)

		if uccv.user_id == self.session.user_id then
			vote_chart.voted[vote] = true
		end
	end

	local vote_charts = {}
	for _, vote_chart in pairs(vote_charts_map) do
		table.insert(vote_charts, vote_chart)
	end
	table.sort(vote_charts, sort_vote_charts)
	params.vote_charts = vote_charts

	return "ok", params
end

return get_votes
