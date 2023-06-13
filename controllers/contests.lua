local Contests = require("models.contests")

local contests_c = {}

function contests_c.GET(self)
	local ctx = self.ctx

	ctx.contests = Contests:select()

	return {render = true}
end

function contests_c.POST(self)
	local time = os.time()
	local contest = Contests:create({
		host_id = self.session.user_id,
		name = time,
		description = "",
		created_at = time,
		started_at = time,
		is_visible = false,
		is_voting_open = false,
		is_submission_open = false,
	})
	contest:update({name = "Contest " .. contest.id})

	return {headers = {
		["HX-Location"] = self:url_for(contest),
	}}
end

return contests_c
