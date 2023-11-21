local delete_chart = {}

delete_chart.policy_set = {
	{"chart_owner"},
	{"is_submission_open", "chart_contest_host"},
}

delete_chart.models = {
	chart = {"charts", {id = "chart_id"}, {"contest"}}
}

function delete_chart.handler(params, models)
	params.chart:delete()
	return "deleted", params
end

return delete_chart
