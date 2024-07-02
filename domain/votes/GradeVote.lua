local IVote = require("domain.votes.IVote")

---@class domain.GradeVote: domain.IVote
---@operator call: domain.GradeVote
---@field voted number?
local GradeVote = IVote + {}

---@param user_id integer
function GradeVote:new(user_id)
	self.user_id = user_id
	self.yes_count = 0
	self.no_count = 0
end

---@param uccv table
function GradeVote:add(uccv)
	self.yes_count = self.yes_count + uccv.value
	self.no_count = self.no_count + 1 - uccv.value
	if uccv.user_id == self.user_id then
		self.voted = uccv.value
	end
end

return GradeVote
