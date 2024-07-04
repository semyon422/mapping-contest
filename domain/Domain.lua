local class = require("class")
local ChartComments = require("domain.ChartComments")
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
	self.repos = repos
	self.oszReader = OszReader(archiveFactory)

	self.roles = Roles(repos.userRolesRepo)
	self.chartComments = ChartComments(repos.chartCommentsRepo, self.roles)
	self.sections = Sections(repos.contestsRepo, repos.sectionsRepo, self.roles)
	self.contestUsers = ContestUsers(repos.contestUsersRepo)
	self.contests = Contests(repos.contestsRepo, self.roles)
	self.tracks = Tracks(
		repos.filesRepo,
		repos.tracksRepo,
		repos.contestsRepo,
		repos.contestUsersRepo,
		self.oszReader,
		self.contests
	)
	self.charts = Charts(
		repos.chartsRepo,
		repos.contestsRepo,
		repos.filesRepo,
		repos.tracksRepo,
		repos.contestUsersRepo,
		repos.usersRepo,
		self.oszReader,
		archiveFactory,
		self.contests,
		self.roles
	)
	self.votes = Votes(
		repos.votesRepo,
		repos.sectionsRepo,
		repos.contestUsersRepo,
		repos.chartsRepo,
		repos.contestsRepo,
		self.sections,
		self.roles
	)
	self.auth = Auth(repos.usersRepo, self.roles, osuApiFactory)
	self.users = Users(repos.usersRepo, self.roles)

	self.anonUser = AnonUser()
end

---@param user_id integer
function Domain:getUser(user_id)
	local anonUser = self.anonUser
	if not user_id then
		return anonUser
	end
	local user = self.repos.usersRepo:findById(user_id)
	if not user then
		return anonUser
	end
	user.user_roles = self.repos.userRolesRepo:select({user_id = user_id})
	return user
end

return Domain
