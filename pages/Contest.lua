local Page = require("web.framework.page.Page")
local relations = require("rdb.relations")
local Datetime = require("util.Datetime")

---@class pages.Contest: web.Page
---@operator call: pages.Contest
local Contest = Page + {}

Contest.view = {layout = "contest"}

function Contest:load()
	local params = self.params
	params.datetime = Datetime(self.config.timezone)

	local contest = params.contest
	self.contest = contest

	relations.preload({self.contest}, {
		"host",
		"sections",
		"contest_users",
		"tracks",
		user_contest_chart_votes = "user",
		charts = {"track", "charter", "file", chart_comments = "user"},
	})

	for _, chart in ipairs(params.contest.charts) do
		chart.name = self.domain.charts.nameGenerator:generate(chart.file.hash)
	end

	self.domain.votes:assign_section(contest.charts, contest.sections, contest.contest_users)
	self.domain.votes:assign_votes(contest.charts, contest.user_contest_chart_votes, params.session_user)

	params.total_noms = self.domain.repos.userRolesRepo:count({role = "elite-mapper"})

	local section_charts = {}
	params.section_charts = section_charts
	for i = 1, #contest.sections do
		section_charts[i] = {}
	end
	for _, chart in ipairs(contest.charts) do
		table.insert(section_charts[chart.section_index], chart)
	end

	local user_id = params.session.user_id
	if user_id then
		for _, contest_user in ipairs(params.contest.contest_users) do
			if contest_user.user_id == user_id then
				params.contest_user = contest_user
				break
			end
		end
	end

	self.contest_users = self.contest.contest_users
end

function Contest:getMaxHearts(section_index)
	return self.domain.sections:get_max_heart_votes(self.user, #self.params.section_charts[section_index])
end

function Contest:canSubmitChart()
	return self.domain.contests:canSubmitChart(self.user, self.contest, self.params.contest_user)
end

function Contest:canJoinContest()
	return self.domain.contests:canJoinContest(self.user)
end

function Contest:canGetTracks()
	return self.domain.contests:canGetTracks(self.user, self.params.contest_user, self.contest)
end

function Contest:canGetVotes()
	return self.domain.contests:canGetVotes(self.user, self.params.contest_user, self.contest)
end

function Contest:canGetChartFile(chart)
	return self.domain.charts:canGetChartFile(self.user, self.params.contest_user, self.contest, chart)
end

function Contest:canUpdateContest()
	return self.domain.contests:canUpdateContest(self.user, self.contest)
end

function Contest:canCreateSection()
	return self.domain.sections:canCreateSection(self.user, self.contest)
end
function Contest:canUpdateSection() return self:canCreateSection() end

function Contest:canSubmitTrack()
	return self.domain.tracks:canSubmitTrack(self.user, self.contest)
end

function Contest:canDeleteTrack(track)
	return self.domain.tracks:canDeleteTrack(self.user, self.contest, track)
end

function Contest:canUpdateVote(chart, vote)
	return self.domain.votes:canUpdateVote(self.user, self.contest, chart, vote)
end

function Contest:canDeleteChart(chart)
	return self.domain.charts:canDelete(self.user, chart, self.contest)
end

function Contest:canCreateComment()
	return self.domain.chartComments:canCreateComment(self.user)
end

function Contest:canDeleteComment(chart_comment)
	return self.domain.chartComments:canDeleteComment(self.user, chart_comment)
end

function Contest:canDecimalGrade()
	return self.domain.votes:canDecimalGrade(self.user)
end

return Contest
