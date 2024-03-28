local relations = require("rdb.relations")
local Sections = require("domain.Sections")
local Votes = require("domain.Votes")
local voting = require("domain.voting")
local Usecase = require("http.Usecase")

---@class usecases.UpdateVote: http.Usecase
---@operator call: usecases.UpdateVote
local UpdateVote = Usecase + {}

function UpdateVote:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:canVote(params.session_user, params.contest, params.chart)
end

UpdateVote.models = {
	contest = {"contests", {id = "contest_id"}},
	chart = {"charts", {id = "chart_id"}},
}

UpdateVote.validate = {
	contest_id = "integer",
	chart_id = "integer",
	vote = {"one_of", unpack(Votes.list)},
}

function UpdateVote:handle(params)
	local models = self.models

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

return UpdateVote
