local class = require("class")

---@class domain.ContestUsers
---@operator call: domain.ContestUsers
local ContestUsers = class()

---@param contestUsersRepo domain.IContestUsersRepo
function ContestUsers:new(contestUsersRepo)
	self.contestUsersRepo = contestUsersRepo
end

function ContestUsers:joinContest(contest_id, user_id)
	self.contestUsersRepo:create({
		contest_id = contest_id,
		user_id = user_id,
		started_at = os.time(),
	})
end

return ContestUsers
