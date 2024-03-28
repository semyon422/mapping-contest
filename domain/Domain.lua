local class = require("class")
local Contests = require("domain.Contests")
local Sections = require("domain.Sections")
local Users = require("domain.Users")
local Tracks = require("domain.Tracks")
local Charts = require("domain.Charts")
local ContestTracks = require("domain.ContestTracks")
local Auth = require("domain.Auth")
local Roles = require("domain.Roles")

---@class domain.Domain
---@operator call: domain.Domain
local Domain = class()

---@param contestsRepo domain.IContestsRepo
---@param sectionsRepo domain.ISectionsRepo
---@param usersRepo domain.IUsersRepo
function Domain:new(contestsRepo, sectionsRepo, usersRepo)
	self.contests = Contests(contestsRepo)
	self.sections = Sections(contestsRepo, sectionsRepo)
	self.contestTracks = ContestTracks()
	self.users = Users(usersRepo)
	self.tracks = Tracks()
	self.charts = Charts()
	self.roles = Roles()
	self.auth = Auth(usersRepo)
end

return Domain
