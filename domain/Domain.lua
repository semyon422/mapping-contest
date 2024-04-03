local class = require("class")
local Contests = require("domain.Contests")
local Sections = require("domain.Sections")
local Users = require("domain.Users")
local Tracks = require("domain.Tracks")
local Charts = require("domain.Charts")
local ContestUsers = require("domain.ContestUsers")
local Auth = require("domain.Auth")
local Roles = require("domain.Roles")
local Votes = require("domain.Votes")
local AnonUser = require("domain.AnonUser")
local OszReader = require("domain.OszReader")

---@class domain.Domain
---@operator call: domain.Domain
local Domain = class()

---@param repos domain.IRepos
---@param osuApiFactory domain.IOsuApiFactory
---@param archiveFactory domain.IArchiveFactory
function Domain:new(repos, osuApiFactory, archiveFactory)
	self.oszReader = OszReader(archiveFactory)

	self.sections = Sections(repos.contestsRepo, repos.sectionsRepo)
	self.contestUsers = ContestUsers(repos.contestUsersRepo)
	self.tracks = Tracks(repos.filesRepo, repos.tracksRepo, self.oszReader)
	self.charts = Charts(
		repos.chartsRepo,
		repos.contestsRepo,
		repos.filesRepo,
		repos.tracksRepo,
		self.oszReader,
		archiveFactory
	)
	self.roles = Roles(repos.userRolesRepo)
	self.votes = Votes(repos.votesRepo, repos.sectionsRepo, repos.contestUsersRepo, repos.chartsRepo)
	self.auth = Auth(repos.usersRepo, repos.userRolesRepo, self.roles, osuApiFactory)
	self.contests = Contests(repos.contestsRepo, self.roles)
	self.users = Users(repos.usersRepo, self.roles)

	self.anonUser = AnonUser()
end

return Domain
