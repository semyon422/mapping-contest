local create_contest = {}

function create_contest.handler(params, models)
	local time = os.time()
	local contest = models.contests:insert({
		host_id = params.session.user_id,
		name = time,
		description = "",
		created_at = time,
		started_at = time,
		is_visible = false,
		is_voting_open = false,
		is_submission_open = false,
	})
	contest:update({name = "Contest " .. contest.id})

	return "ok", params
end

return create_contest