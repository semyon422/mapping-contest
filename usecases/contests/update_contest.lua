local update_contest = {}

update_contest.access = {{"contest_host"}}

update_contest.models = {contest = {"contests", {id = "contest_id"}}}

update_contest.validate = {
	name = {"*", "string", {"#", 1, 128}},
	description = {"*", "string", {"#", 1, 1024}},
	is_visible = "boolean",
	is_submission_open = "boolean",
	is_voting_open = "boolean",
}

function update_contest:handle(params)
	local _contest = self.models.contests:find({name = params.name})
	if _contest and _contest.id ~= params.contest.id then
		params.errors = {"This name is already taken"}
		return "validation", params
	end

	params.contest:update({
		name = params.name,
		description = params.description,
		is_visible = params.is_visible,
		is_voting_open = params.is_voting_open,
		is_submission_open = params.is_submission_open,
	})

	return "ok", params
end

return update_contest
