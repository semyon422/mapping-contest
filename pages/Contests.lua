local Page = require("http.Page")

---@class pages.Contests: http.Page
---@operator call: pages.Contests
local Contests = Page + {}

Contests.view = {layout = "contests"}

function Contests:canCreateContest()
	return self.domain.contests:canCreateContest(self.user)
end

function Contests:canGetContest(contest)
	return self.domain.contests:isContestAccessable(self.user, contest)
end

return Contests
