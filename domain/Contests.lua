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

function Contests:canGetContest(user, contest)
	return contest.is_visible or user.id == contest.host_id
end

function Contests:canUpdateContest(user, contest)
	return user.id == contest.host_id
end

function Contests:canCreateContest(user)
	return self.roles:hasRole(user, "host")
end

function Contests:canGetTracks(user, contest_user, contest)
	return contest_user ~= nil or self:canUpdateContest(user, contest)
end

function Contests:canGetVotes(user, contest_user, contest)
	return contest_user ~= nil or not contest.is_submission_open or self:canUpdateContest(user, contest)
end

function Contests:canSubmitChart(user, contest, contest_user)
	return contest.is_submission_open and contest_user ~= nil and self.roles:hasRole(user, "verified")
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
	if not self:canGetContest(user, contest) then
		return nil, Errors.forbidden
	end
	return contest
end

function Contests:getContests()
	return self.contestsRepo:select()
end

function Contests:createContest(user)
	if not self:canCreateContest(user) then
		return
	end

	local time = os.time()
	local contest = self.contestsRepo:create({
		host_id = user.id,
		name = time,
		description = "",
		created_at = time,
		is_visible = false,
		is_voting_open = false,
		is_submission_open = false,
		is_anon = true,
	})
	contest.name = "Contest " .. contest.id
	self.contestsRepo:update(contest)

	return contest
end

function Contests:deleteContest(user, contest_id)
	local contest = self.contestsRepo:findById(contest_id)
	if not self:canUpdateContest(user, contest) then
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
	if not self:canUpdateContest(user, contest) then
		return
	end

	self.contestsRepo:update({
		id = contest_id,
		name = params.name,
		description = params.description,
		is_visible = params.is_visible,
		is_voting_open = params.is_voting_open,
		is_submission_open = params.is_submission_open,
		is_anon = params.is_anon,
	})
end

return Contests
