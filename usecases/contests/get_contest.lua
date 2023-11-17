local relations = require("rdb.relations")
local Votes = require("domain.Votes")

local get_contest = {}

get_contest.policy_set = {
	{"contest_visible"},
	{"contest_host"},
}

get_contest.models = {contest = {"contests", {id = "contest_id"}}}

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

local function load_vote_charts(params)
	local vote_charts_map = {}
	for _, chart in ipairs(params.contest.charts) do
		vote_charts_map[chart.id] = new_vote_chart(chart)
	end

	for _, uccv in ipairs(params.contest.user_contest_chart_votes) do
		local vote_chart = vote_charts_map[uccv.chart_id]

		local vote = uccv.vote
		table.insert(vote_chart[vote], uccv.user)

		if uccv.user_id == params.session.user_id then
			vote_chart.voted[vote] = true
		end
	end

	local vote_charts = {}
	for _, vote_chart in pairs(vote_charts_map) do
		table.insert(vote_charts, vote_chart)
	end
	params.vote_charts = vote_charts
end

local function get_section(duration, notes, sections)
	for i, section in ipairs(sections) do
		if duration <= (section.time_base + section.time_per_knote * notes / 1000) * 60 then
			return i
		end
	end
	return #sections
end

local function load_sections(params)
	local sections = params.contest.sections
	if #sections == 0 then
		return
	end

	table.sort(sections, function(a, b)
		return a.time_base < b.time_base
	end)

	local charts = {}
	params.section_vote_charts = charts
	for i = 1, #sections do
		charts[i] = {}
	end

	for _, vote_chart in ipairs(params.vote_charts) do
		local chart = vote_chart.chart
		local started_at
		for _, contest_user in ipairs(params.contest.contest_users) do
			if contest_user.user_id == chart.charter_id then
				started_at = contest_user.started_at
				break
			end
		end
		vote_chart.started_at = started_at

		local notes = chart.notes
		local submitted_at = chart.submitted_at
		local section_index = get_section(submitted_at - started_at, notes, sections)
		table.insert(charts[section_index], vote_chart)
	end

	for _, vote_charts in ipairs(charts) do
		table.sort(vote_charts, function(a, b)
			return a.chart.id < b.chart.id
		end)
	end
end

function get_contest.handler(params, models)
	relations.preload({params.contest}, {
		"host",
		"sections",
		"contest_users",
		user_contest_chart_votes = "user",
		contest_tracks = "track",
		charts = {"track", "charter"},
	})

	load_vote_charts(params)
	load_sections(params)

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
