local Usecase = require("http.Usecase")

---@class usecases.UpdateContest: http.Usecase
---@operator call: usecases.UpdateContest
local UpdateContest = Usecase + {}

UpdateContest.models = {contest = {"contests", {id = "contest_id"}}}

UpdateContest.validate = {
	name = {"*", "string", {"#", 1, 128}},
	description = {"*", "string", {"#", 1, 1024}},
	is_visible = "boolean",
	is_submission_open = "boolean",
	is_voting_open = "boolean",
}

function UpdateContest:authorize(params)
	if not params.session_user then return end
	return self.domain.contests:isContestEditable(params.session_user, params.contest)
end

function UpdateContest:handle(params)
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

return UpdateContest
