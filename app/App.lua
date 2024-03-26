local class = require("class")
local AppDatabase = require("app.AppDatabase")
local WebApp = require("http.WebApp")
local Domain = require("domain.Domain")
local ContestsRepo = require("app.repos.ContestsRepo")

---@class app.App
---@operator call: app.App
local App = class()

function App:new()
	self.appDatabase = AppDatabase()

	self.contestsRepo = ContestsRepo(self.appDatabase)
	self.domain = Domain(self.contestsRepo)

	local config = require("lapis.config").get()
	self.webApp = WebApp(config, self.domain)
end

function App:load()
	self.appDatabase:load()
end

return App
