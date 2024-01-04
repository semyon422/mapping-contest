local join_contest = {}

join_contest.access = {{"role_verified"}}

join_contest.models = {contest = {"contests", {id = "contest_id"}}}

function join_contest.handle(params, models)
	models.contest_users:create({
		contest_id = params.contest_id,
		user_id = params.session.user_id,
		started_at = os.time(),
	})

	return "ok", params
end

return join_contest
