local class = require("class")
local AppDatabase = require("app.AppDatabase")
local WebApp = require("http.WebApp")
local Domain = require("domain.Domain")

local Repos = require("app.repos.Repos")
local OsuApiFactory = require("app.external.OsuApiFactory")

---@class app.App
---@operator call: app.App
local App = class()

function App:new()
	local config = require("lapis.config").get()

	self.appDatabase = AppDatabase()
	self.osuApiFactory = OsuApiFactory(config.osu_oauth)

	self.repos = Repos(self.appDatabase)
	self.domain = Domain(self.repos, self.osuApiFactory)

	self.webApp = WebApp(config, self.domain, self.appDatabase.models)
end

function App:load()
	self.appDatabase:load()
end

return App
