local relations = require("rdb.relations")
local Sections = require("domain.Sections")

local update_vote = {}

update_vote.policy_set = {{"role_verified", "contest_voting_open"}}

function update_vote.handler(params, models)
	local uccv = {
		contest_id = params.contest_id,
		user_id = params.session.user_id,
		chart_id = params.chart_id,
		vote = params.vote,
	}
	local found_uccv = models.user_contest_chart_votes:select(uccv)[1]
	if found_uccv then
		found_uccv:delete()
		return "ok", {}
	end

	if params.vote == "yes" or params.vote == "no" then
		local opposite = params.vote == "yes" and "no" or "yes"
		local opposite_uccv = models.user_contest_chart_votes:select({
			contest_id = params.contest_id,
			user_id = params.session.user_id,
			chart_id = params.chart_id,
			vote = opposite,
		})[1]
		if opposite_uccv then
			opposite_uccv:delete()
		end
		models.user_contest_chart_votes:create(uccv)
		return "ok", {}
	end

	local base_chart = models.charts:select(params.chart_id)[1]
	local section_charts = {}

	for _, chart in ipairs(params.contest:get_charts()) do
		if chart.section == base_chart.section then
			table.insert(section_charts, chart)
		end
	end

	local heart_uccvs = models.user_contest_chart_votes:select({
		contest_id = params.contest_id,
		user_id = params.session.user_id,
		vote = "heart",
	})
	relations.preload(heart_uccvs, "chart")

	local user_hearts = 0
	for _, _uccv in ipairs(heart_uccvs) do
		if _uccv.chart.section == base_chart.section then
			user_hearts = user_hearts + 1
		end
	end

	if user_hearts >= Sections:get_max_heart_votes(#section_charts) then
		return
	end

	models.user_contest_chart_votes:insert(uccv)

	return "ok", params
end

return update_vote
