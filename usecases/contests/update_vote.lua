local relations = require("rdb.relations")
local Sections = require("domain.Sections")
local Votes = require("domain.Votes")
local types = require("lapis.validate.types")
local voting = require("domain.voting")

local update_vote = {}

update_vote.policy_set = {
	{"role_verified", "contest_voting_open", "not_charter"}
}

update_vote.models = {
	contest = {"contests", {id = "contest_id"}},
	chart = {"charts", {id = "chart_id"}},
}

update_vote.validate = types.partial({
	contest_id = types.db_id,
	chart_id = types.db_id,
	vote = types.one_of(Votes.list),
})

function update_vote.handler(params, models)
	local uccv = {
		contest_id = params.contest_id,
		user_id = params.session.user_id,
		chart_id = params.chart_id,
		vote = params.vote,
	}
	if models.user_contest_chart_votes:delete(uccv)[1] then
		return "ok", {}
	end

	if params.vote == "yes" or params.vote == "no" then
		uccv.vote = params.vote == "yes" and "no" or "yes"
		models.user_contest_chart_votes:delete(uccv)
		uccv.vote = params.vote
		models.user_contest_chart_votes:create(uccv)
		return "ok", {}
	end

	relations.preload({params.contest}, {
		"sections",
		"contest_users",
		"user_contest_chart_votes",
		"charts",
	})

	local _chart = params.chart

	local section_vote_charts = assert(voting.load_sections(params))
	local sections = params.contest.sections

	local chart_section_index
	for i = 1, #sections do
		for _, vote_chart in ipairs(section_vote_charts[i]) do
			if vote_chart.chart.id == _chart.id then
				chart_section_index = i
				break
			end
		end
	end
	assert(chart_section_index)

	local s_charts_count = #section_vote_charts[chart_section_index]
	local chart_in_section = {}
	for _, vote_chart in ipairs(section_vote_charts[chart_section_index]) do
		chart_in_section[vote_chart.chart.id] = true
	end

	local heart_uccvs = models.user_contest_chart_votes:select({
		contest_id = params.contest_id,
		user_id = params.session.user_id,
		vote = "heart",
	})

	local user_hearts = 0
	for _, _uccv in ipairs(heart_uccvs) do
		if chart_in_section[_uccv.chart_id] then
			user_hearts = user_hearts + 1
		end
	end

	if user_hearts >= Sections:get_max_heart_votes(s_charts_count) then
		return
	end

	models.user_contest_chart_votes:create(uccv)

	return "ok", params
end

return update_vote
