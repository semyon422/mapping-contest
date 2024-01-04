local Datetime = require("util.datetime")
local types = require("lapis.validate.types")

local update_contest = {}

update_contest.access = {{"contest_host"}}

update_contest.models = {contest = {"contests", {id = "contest_id"}}}

update_contest.validate = types.partial({
	name = types.limited_text(128),
	description = types.limited_text(1024),
	is_visible = types.string + types.empty,
	is_submission_open = types.string + types.empty,
	is_voting_open = types.string + types.empty,
})

function update_contest.handle(params, models)
	local _contest = models.contests:find({name = params.name})
	if _contest and _contest.id ~= params.contest.id then
		params.errors = {"This name is already taken"}
		return "validation", params
	end

	params.contest:update({
		name = params.name,
		description = params.description,
		is_visible = params.is_visible == "on",
		is_voting_open = params.is_voting_open == "on",
		is_submission_open = params.is_submission_open == "on",
	})

	return "ok", params
end

return update_contest
