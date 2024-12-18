local class = require("class")
local autoread = require("autoread")
local AppDatabase = require("app.AppDatabase")
local WebApp = require("web.framework.WebApp")
local Domain = require("domain.Domain")

local Repos = require("app.repos.Repos")
local OsuApiFactory = require("app.external.OsuApiFactory")
local ArchiveFactory = require("app.external.ArchiveFactory")
local config = require("config")

---@class app.App
---@operator call: app.App
local App = class()

function App:new()
	self.appDatabase = AppDatabase(autoread("app/migrate/%s.sql"))
	self.osuApiFactory = OsuApiFactory(config.osu_oauth)
	self.archiveFactory = ArchiveFactory()

	self.repos = Repos(self.appDatabase)
	self.domain = Domain(self.repos, self.osuApiFactory, self.archiveFactory)

	self.webApp = WebApp(config, self.domain)
end

function App:load()
	self.appDatabase:load()
end

function App:createTestDatabase()
	local user = self.domain.auth:register("admin", "password", "discord")
	self.domain.roles:give(user.id, "admin")
end

return App
