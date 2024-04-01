local class = require("class")

---@class domain.IRepos
---@operator call: domain.IRepos
---@field chartsRepo domain.IChartsRepo
---@field contestsRepo domain.IContestsRepo
---@field contestUsersRepo domain.IContestUsersRepo
---@field filesRepo domain.IFilesRepo
---@field sectionsRepo domain.ISectionsRepo
---@field tracksRepo domain.ITracksRepo
---@field userRolesRepo domain.IUserRolesRepo
---@field usersRepo domain.IUsersRepo
---@field votesRepo domain.IVotesRepo
local IRepos = class()

return IRepos
