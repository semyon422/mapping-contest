local delete_chart = {}

delete_chart.access = {
	{"is_submission_open", "chart_owner"},
	{"chart_contest_host"},
}

delete_chart.models = {
	contest = {"contests", {id = "contest_id"}},
	chart = {"charts", {id = "chart_id"}, {"contest"}},  -- TODO: refactor this, contest loads twice
}

function delete_chart.handle(params, models)
	params.chart:delete()
	return "deleted", params
end

return delete_chart
