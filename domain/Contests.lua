local class = require("class")
local Errors = require("domain.Errors")

---@class domain.Contests
---@operator call: domain.Contests
local Contests = class()

---@param contestsRepo domain.IContestsRepo
function Contests:new(contestsRepo)
	self.contestsRepo = contestsRepo
end

function Contests:isContestAccessable(user, contest)
	return contest.is_visible or user.id == contest.host_id
end

function Contests:getContest(user, contest_id)
	local contest = self.contestsRepo:getContestById(contest_id)
	if not contest then
		return nil, Errors.not_found
	end
	if not self:isContestAccessable(user, contest) then
		return nil, Errors.forbidden
	end
	return contest
end

return Contests
