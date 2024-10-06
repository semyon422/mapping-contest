local Page = require("web.page.Page")

---@class pages.Contests: web.Page
---@operator call: pages.Contests
local Contests = Page + {}

Contests.view = {layout = "contests"}

function Contests:canCreateContest()
	return self.domain.contests:canCreateContest(self.user)
end

function Contests:canGetContest(contest)
	return self.domain.contests:canGetContest(self.user, contest)
end

return Contests
