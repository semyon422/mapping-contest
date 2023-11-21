local create_contest = {}

create_contest.policy_set = {{"role_host"}}

function create_contest.handler(params, models)
	local time = os.time()
	local contest = models.contests:create({
		host_id = params.session.user_id,
		name = time,
		description = "",
		created_at = time,
		is_visible = false,
		is_voting_open = false,
		is_submission_open = false,
	})
	contest:update({name = "Contest " .. contest.id})
	params.contest = contest

	return "created", params
end

return create_contest
