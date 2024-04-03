local Page = require("http.Page")
local relations = require("rdb.relations")
local voting = require("domain.voting")

---@class pages.Contest: http.Page
---@operator call: pages.Contest
local Contest = Page + {}

Contest.view = {layout = "contest"}

function Contest:load()
	local params = self.params
	self.contest = params.contest

	relations.preload({self.contest}, {
		"host",
		"sections",
		"contest_users",
		"tracks",
		user_contest_chart_votes = "user",
		charts = {"track", "charter", "file"},
	})

	for _, chart in ipairs(params.contest.charts) do
		chart.name = self.domain.charts.nameGenerator:generate(chart.file.hash)
	end

	params.section_vote_charts = voting.load_sections(params)

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

function Contest:canSubmitChart()
	return self.domain.contests:canSubmitChart(self.user, self.contest, self.contest_users)
end

function Contest:canJoinContest()
	return self.domain.contests:canJoinContest(self.user)
end

function Contest:canUpdateContest()
	return self.domain.contests:isContestEditable(self.user, self.contest)
end

function Contest:canSubmitTrack()
	return self:canUpdateContest()
end

function Contest:canDeleteTrack(track)
	return self:canUpdateContest()
end

function Contest:canCreateSection()
	return self:canUpdateContest()
end

function Contest:canUpdateVote(chart)
	return self.domain.votes:canUpdateVote(chart)
end

function Contest:canDeleteChart(chart)
	return self.domain.charts:canDelete(self.user, chart, self.contest)
end

return Contest
