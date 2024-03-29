local enum = require("util.enum")
local class = require("class")
local Sections = require("domain.Sections")

---@class domain.Votes
---@operator call: domain.Votes
local Votes = class()

---@param votesRepo domain.IVotesRepo
---@param sectionsRepo domain.ISectionsRepo
---@param contestUsersRepo domain.IContestUsersRepo
---@param chartsRepo domain.IChartsRepo
function Votes:new(votesRepo, sectionsRepo, contestUsersRepo, chartsRepo)
	self.votesRepo = votesRepo
	self.sectionsRepo = sectionsRepo
	self.contestUsersRepo = contestUsersRepo
	self.chartsRepo = chartsRepo
end

Votes.enum = enum({
	yes = 0,
	no = 1,
	heart = 2,
})

Votes.list = {
	"yes",
	"no",
	"heart",
}

local function get_section(duration, notes, sections)
	for i, section in ipairs(sections) do
		if duration <= (section.time_base + section.time_per_knote * notes / 1000) * 60 then
			return i
		end
	end
	return #sections
end


-- UpdateVote.validate = {
-- 	contest_id = "integer",
-- 	chart_id = "integer",
-- 	vote = {"one_of", unpack(Votes.list)},
-- }

local function get_chart_contest_user(chart, contest_users)
	for _, contest_user in ipairs(contest_users) do
		if contest_user.user_id == chart.charter_id then
			return contest_user
		end
	end
end

local function assign_section(charts, sections, contest_users)
	for _, chart in ipairs(charts) do
		local contest_user = get_chart_contest_user(chart, contest_users)
		local duration = chart.submitted_at - contest_user.started_at
		chart.section_index = get_section(duration, chart.notes, sections)
	end
end

function Votes:canUpdateVote(user, contest, chart, vote)

end

function Votes:updateVote(user, contest_id, chart_id, vote)
	local uccv = {
		contest_id = contest_id,
		user_id = user.id,
		chart_id = chart_id,
		vote = vote,
	}
	if self.votesRepo:delete(uccv)[1] then
		return
	end

	if vote == "yes" or vote == "no" then
		uccv.vote = vote == "yes" and "no" or "yes"
		self.votesRepo:delete(uccv)
		uccv.vote = vote
		self.votesRepo:create(uccv)
		return
	end

	local sections = self.sectionsRepo:select({contest_id = contest_id})
	local contest_users = self.contestUsersRepo:select({contest_id = contest_id})
	local charts = self.chartsRepo:select({contest_id = contest_id})

	assign_section(charts, sections, contest_users)

	local chart
	for _, _chart in ipairs(charts) do
		if _chart.id == chart_id then
			chart = chart
		end
	end
	local section_index = chart.section_index

	local charts_in_section = {}
	for _, _chart in ipairs(charts) do
		if _chart.section_index == section_index then
			table.insert(charts_in_section, _chart.id)
		end
	end

	local heart_uccvs = self.votesRepo:select({
		contest_id = contest_id,
		user_id = user.id,
		vote = "heart",
		chart_id__in = charts_in_section,
	})

	local user_hearts = #heart_uccvs

	if user_hearts >= Sections:get_max_heart_votes(#charts_in_section) then
		return
	end

	self.votesRepo:create(uccv)
end

return Votes
