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

function Contests:isContestEditable(user, contest)
	return user.id == contest.host_id
end

function Contests:getContest(user, contest_id)
	local contest = self.contestsRepo:getById(contest_id)
	if not contest then
		return nil, Errors.not_found
	end
	if not self:isContestAccessable(user, contest) then
		return nil, Errors.forbidden
	end
	return contest
end

function Contests:getContests()
	return self.contestsRepo:getAll()
end

function Contests:createContest(user)
	-- TODO: check host role, validate contest
	local contest = self.contestsRepo:create({
		host_id = user.id,
	})

	-- local time = os.time()
	-- local contest = self.models.contests:create({
	-- 	host_id = params.session.user_id,
	-- 	name = time,
	-- 	description = "",
	-- 	created_at = time,
	-- 	is_visible = false,
	-- 	is_voting_open = false,
	-- 	is_submission_open = false,
	-- })
	-- contest:update({name = "Contest " .. contest.id})

	return contest
end

function Contests:canCreateContest(user)
	-- return self.domain.roles:hasRole(params.session_user, "host")
end

function Contests:canSubmitChart(user, contest)
	-- {{"role_verified", "contest_user", "is_submission_open"}}
end

function Contests:canJoinContest(user, contest)
	-- {{"role_verified"}}
end

function Contests:canVote(user, contest, chart)
	-- {"role_verified", "contest_voting_open", "not_charter"}
end

return Contests
