local User_contest_chart_votes = require("models.user_contest_chart_votes")
local Charts = require("models.charts")
local Votes = require("enums.votes")
local Sections = require("enums.sections")
local preload = require("lapis.db.model").preload
local types = require("lapis.validate.types")
local with_params = require("lapis.validate").with_params

local uccv_c = {}

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

function uccv_c.GET(self)
	local ctx = self.ctx

	preload({ctx.contest}, {
		user_contest_chart_votes = "user",
		charts = {"track", "charter"}
	})

	local vote_charts_map = {}
	for _, chart in ipairs(ctx.contest.charts) do
		chart.section = Sections:to_name(chart.section)
		vote_charts_map[chart.id] = new_vote_chart(chart)
	end

	for _, uccv in ipairs(ctx.contest.user_contest_chart_votes) do
		local vote_chart = vote_charts_map[uccv.chart_id]

		local vote = Votes:to_name(uccv.vote)
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
	ctx.vote_charts = vote_charts

	return {render = true}
end

uccv_c.PATCH = with_params({
	{"contest_id", types.db_id},
	{"chart_id", types.db_id},
	{"vote", types.one_of(Votes.list)},
}, function(self, params)
	local uccv = {
		contest_id = params.contest_id,
		user_id = self.session.user_id,
		chart_id = params.chart_id,
		vote = Votes:for_db(params.vote),
	}
	local found_uccv = User_contest_chart_votes:find(uccv)
	if found_uccv then
		found_uccv:delete()
		return
	end

	local ctx = self.ctx

	if params.vote == "yes" or params.vote == "no" then
		local opposite = params.vote == "yes" and "no" or "yes"
		local opposite_uccv = User_contest_chart_votes:find({
			contest_id = params.contest_id,
			user_id = self.session.user_id,
			chart_id = params.chart_id,
			vote = Votes:for_db(opposite),
		})
		if opposite_uccv then
			opposite_uccv:delete()
		end
		User_contest_chart_votes:create(uccv)
		return
	end

	local base_chart = Charts:find(params.chart_id)
	local section_charts = {}

	for _, chart in ipairs(ctx.contest:get_charts()) do
		if chart.section == base_chart.section then
			table.insert(section_charts, chart)
		end
	end

	local heart_uccvs = User_contest_chart_votes:select(
		"where contest_id = ? and user_id = ? and vote = ?",
		params.contest_id, self.session.user_id, Votes:for_db("heart")
	)
	preload(heart_uccvs, "chart")

	local user_hearts = 0
	for _, _uccv in ipairs(heart_uccvs) do
		if _uccv.chart.section == base_chart.section then
			user_hearts = user_hearts + 1
		end
	end

	if user_hearts >= Sections:get_max_heart_votes(#section_charts) then
		return
	end

	User_contest_chart_votes:create(uccv)
end)

return uccv_c
