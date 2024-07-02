local class = require("class")
local GradeVote = require("domain.votes.GradeVote")
local HeartVote = require("domain.votes.HeartVote")

---@class domain.ChartVotes
---@operator call: domain.ChartVotes
---@field [string] domain.IVote
local ChartVotes = class()

---@param user_id integer
function ChartVotes:new(user_id)
	self.grade = GradeVote(user_id)
	self.heart = HeartVote(user_id)
end

---@param uccv table
function ChartVotes:add(uccv)
	local vote = self[uccv.vote]
	---@cast vote domain.IVote
	vote:add(uccv)
end

return ChartVotes
