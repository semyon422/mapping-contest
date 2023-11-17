local join_contest = {}

join_contest.policy_set = {{"role_verified"}}

join_contest.models = {contest = {"contests", {id = "contest_id"}}}

function join_contest.handler(params, models)
	local started_at = params.contest.started_at

	models.contest_users:create({
		contest_id = params.contest_id,
		user_id = params.session.user_id,
		started_at = math.max(os.time(), started_at),
	})

	return "ok", params
end

return join_contest
