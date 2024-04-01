local class = require("class")
local Errors = require("domain.Errors")

---@class domain.Contests
---@operator call: domain.Contests
local Contests = class()

---@param contestsRepo domain.IContestsRepo
---@param roles domain.Roles
function Contests:new(contestsRepo, roles)
	self.contestsRepo = contestsRepo
	self.roles = roles
end

function Contests:isContestAccessable(user, contest)
	return contest.is_visible or user.id == contest.host_id
end

function Contests:isContestEditable(user, contest)
	return user.id == contest.host_id
end

function Contests:canCreateContest(user)
	return self.roles:hasRole(user, "host")
end

function Contests:canSubmitChart(user, contest, contest_users)
	local _contest_user
	for _, contest_user in ipairs(contest_users) do
		if contest_user.user_id == user.id then
			_contest_user = contest_user
			break
		end
	end
	return contest.is_submission_open and _contest_user and self.roles:hasRole(user, "verified")
end

function Contests:canJoinContest(user)
	return self.roles:hasRole(user, "verified")
end

function Contests:canVote(user, contest, chart)
	return contest.is_voting_open and user.id ~= chart.charter_id and self.roles:hasRole(user, "verified")
end

function Contests:getContest(user, contest_id)
	local contest = self.contestsRepo:findById(contest_id)
	if not contest then
		return nil, Errors.not_found
	end
	if not self:isContestAccessable(user, contest) then
		return nil, Errors.forbidden
	end
	return contest
end

function Contests:getContests()
	return self.contestsRepo:select()
end

function Contests:createContest(user)
	-- TODO: check host role, validate contest
	local time = os.time()
	local contest = self.contestsRepo:create({
		host_id = user.id,
		name = time,
		description = "",
		created_at = time,
		is_visible = false,
		is_voting_open = false,
		is_submission_open = false,
	})
	contest.name = "Contest " .. contest.id
	self.contestsRepo:update(contest)

	return contest
end

function Contests:deleteContest(user, contest_id)
	local contest = self.contestsRepo:findById(contest_id)
	if not self:isContestEditable(user, contest) then
		return
	end
	self.contestsRepo:deleteById(contest_id)
end


-- UpdateContest.validate = {
-- 	name = {"*", "string", {"#", 1, 128}},
-- 	description = {"*", "string", {"#", 1, 1024}},
-- 	is_visible = "boolean",
-- 	is_submission_open = "boolean",
-- 	is_voting_open = "boolean",
-- }

function Contests:updateContest(user, contest_id, params)
	local contest = self.contestsRepo:findById(contest_id)
	if not self:isContestEditable(user, contest) then
		return
	end

	self.contestsRepo:update({
		id = contest_id,
		name = params.name,
		description = params.description,
		is_visible = params.is_visible,
		is_voting_open = params.is_voting_open,
		is_submission_open = params.is_submission_open,
	})
end

return Contests
