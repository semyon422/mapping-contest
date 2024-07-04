local IVote = require("domain.votes.IVote")

---@class domain.HeartVote: domain.IVote
---@operator call: domain.HeartVote
---@field value number?
local HeartVote = IVote + {}

---@param user_id integer
function HeartVote:new(user_id)
	self.user_id = user_id
	self.count = 0
	self.nom_users = {}
end

---@param uccv table
function HeartVote:add(uccv)
	self.count = self.count + 1
	if uccv.user_id == self.user_id then
		self.value = uccv.value
		if uccv.value == 1 then
			table.insert(self.nom_users, uccv.user)
		end
	end
end

return HeartVote
