local class = require("class")
local Contests = require("domain.Contests")
local Sections = require("domain.Sections")
local Users = require("domain.Users")
local Tracks = require("domain.Tracks")
local Charts = require("domain.Charts")
local ContestTracks = require("domain.ContestTracks")
local ContestUsers = require("domain.ContestUsers")
local Auth = require("domain.Auth")
local Roles = require("domain.Roles")
local Votes = require("domain.Votes")

---@class domain.Domain
---@operator call: domain.Domain
local Domain = class()

---@param repos domain.IRepos
function Domain:new(repos)
	self.sections = Sections(repos.contestsRepo, repos.sectionsRepo)
	self.contestTracks = ContestTracks(repos.contestTracksRepo, repos.filesRepo, repos.tracksRepo)
	self.contestUsers = ContestUsers(repos.contestUsersRepo)
	self.tracks = Tracks()
	self.charts = Charts(repos.chartsRepo, repos.contestsRepo, repos.filesRepo, repos.tracksRepo)
	self.roles = Roles(repos.userRolesRepo)
	self.votes = Votes(repos.votesRepo, repos.sectionsRepo, repos.contestUsersRepo, repos.chartsRepo)
	self.auth = Auth(repos.usersRepo, repos.userRolesRepo, self.roles)
	self.contests = Contests(repos.contestsRepo, self.roles)
	self.users = Users(repos.usersRepo, self.roles)
end

return Domain
