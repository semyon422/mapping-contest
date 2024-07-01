local IRepos = require("domain.repos.IRepos")

local ChartCommentsRepo = require("app.repos.ChartCommentsRepo")
local ChartsRepo = require("app.repos.ChartsRepo")
local ContestsRepo = require("app.repos.ContestsRepo")
local ContestUsersRepo = require("app.repos.ContestUsersRepo")
local FilesRepo = require("app.repos.FilesRepo")
local SectionsRepo = require("app.repos.SectionsRepo")
local TracksRepo = require("app.repos.TracksRepo")
local UserRolesRepo = require("app.repos.UserRolesRepo")
local UsersRepo = require("app.repos.UsersRepo")
local VotesRepo = require("app.repos.VotesRepo")

---@class app.IRepos: domain.IRepos
---@operator call: app.IRepos
local Repos = IRepos + {}

---@param appDatabase app.AppDatabase
function Repos:new(appDatabase)
	self.chartCommentsRepo = ChartCommentsRepo(appDatabase)
	self.chartsRepo = ChartsRepo(appDatabase)
	self.contestsRepo = ContestsRepo(appDatabase)
	self.contestUsersRepo = ContestUsersRepo(appDatabase)
	self.filesRepo = FilesRepo(appDatabase)
	self.sectionsRepo = SectionsRepo(appDatabase)
	self.tracksRepo = TracksRepo(appDatabase)
	self.userRolesRepo = UserRolesRepo(appDatabase)
	self.usersRepo = UsersRepo(appDatabase)
	self.votesRepo = VotesRepo(appDatabase)
end

return Repos
