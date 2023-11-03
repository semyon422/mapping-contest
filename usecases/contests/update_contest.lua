local Datetime = require("util.datetime")

local update_contest = {}

update_contest.policy_set = {{"contest_host"}}

update_contest.models = {contest = {"contests", {id = "contest_id"}}}

function update_contest.handler(params, models)
	local _contest = models.contests:select({name = params.name})[1]
	if _contest and _contest.id ~= params.contest.id then
		params.errors = {"This name is already taken"}
		return "validation", params
	end

	params.contest:update({
		name = params.name,
		description = params.description,
		started_at = Datetime.to_unix(params.started_at),
		is_visible = params.is_visible == "on",
		is_voting_open = params.is_voting_open == "on",
		is_submission_open = params.is_submission_open == "on",
	})

	return "ok", params
end

return update_contest
