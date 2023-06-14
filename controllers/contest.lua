local preload = require("lapis.db.model").preload
local Datetime = require("util.datetime")
local Contests = require("models.contests")
local types = require("lapis.validate.types")
local with_params = require("lapis.validate").with_params

local contest_c = {}

function contest_c.before(self)
	local ctx = self.ctx

	preload({ctx.contest}, {
		"host",
		contest_tracks = "track",
		charts = {"track", "charter"}
	})
	for _, chart in ipairs(ctx.contest.charts) do
		chart.contest = ctx.contest
	end
end

contest_c.GET = function(self)
	return {render = true}
end

contest_c.PATCH = with_params({
	{"name", types.limited_text(128)},
	{"description", types.limited_text(1024)},
	{"started_at", types.valid_text},
	{"is_visible", types.string + types.empty},
	{"is_submission_open", types.string + types.empty},
	{"is_voting_open", types.string + types.empty},
}, function(self, params)
	local ctx = self.ctx

	local _contest = Contests:find({name = params.name})
	if _contest and _contest.id ~= ctx.contest.id then
		self.errors = {"This name is already taken"}
		return {render = "errors", layout = false}
	end

	local contest = ctx.contest
	contest.name = params.name
	contest.description = params.description
	contest.started_at = Datetime.to_unix(params.started_at)
	contest.is_visible = params.is_visible == "on"
	contest.is_voting_open = params.is_voting_open == "on"
	contest.is_submission_open = params.is_submission_open == "on"
	contest:update(
		"name",
		"description",
		"started_at",
		"is_visible",
		"is_voting_open",
		"is_submission_open"
	)

	return {headers = {["HX-Location"] = self:url_for(contest)}}
end)

return contest_c
