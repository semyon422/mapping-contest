local class = require("class")
local Contests = require("domain.Contests")
local Users = require("domain.Users")
local Tracks = require("domain.Tracks")
local Charts = require("domain.Charts")

---@class domain.Domain
---@operator call: domain.Domain
local Domain = class()

---@param contestsRepo domain.IContestsRepo
function Domain:new(contestsRepo)
	self.contests = Contests(contestsRepo)
	self.users = Users()
	self.tracks = Tracks()
	self.charts = Charts()
end

return Domain
