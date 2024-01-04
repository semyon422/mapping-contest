local delete_contest = {}

delete_contest.access = {{"contest_host"}}

delete_contest.models = {contest = {"contests", {id = "contest_id"}}}

function delete_contest.handle(params, models)
	params.contest:delete()
	return "deleted", params
end

return delete_contest
