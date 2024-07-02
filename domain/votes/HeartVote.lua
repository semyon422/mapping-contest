local IVote = require("domain.votes.IVote")

---@class domain.HeartVote: domain.IVote
---@operator call: domain.HeartVote
local HeartVote = IVote + {}

---@param user_id integer
function HeartVote:new(user_id)
	self.user_id = user_id
	self.count = 0
	self.voted = false
end

---@param uccv table
function HeartVote:add(uccv)
	self.count = self.count + 1
	if uccv.user_id == self.user_id then
		self.voted = true
	end
end

return HeartVote
