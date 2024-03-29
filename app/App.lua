local class = require("class")
local AppDatabase = require("app.AppDatabase")
local WebApp = require("http.WebApp")
local Domain = require("domain.Domain")

local Repos = require("app.repos.Repos")

---@class app.App
---@operator call: app.App
local App = class()

function App:new()
	self.appDatabase = AppDatabase()

	self.repos = Repos(self.appDatabase)
	self.domain = Domain(self.repos)

	local config = require("lapis.config").get()
	self.webApp = WebApp(config, self.domain, self.appDatabase.models)
end

function App:load()
	self.appDatabase:load()
end

return App
