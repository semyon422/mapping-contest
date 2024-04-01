local class = require("class")
local LsqliteDatabase = require("rdb.LsqliteDatabase")
local TableOrm = require("rdb.TableOrm")
local Models = require("rdb.Models")
local autoload = require("autoload")
local ls = require("ls")

---@class app.AppDatabase
---@operator call: app.AppDatabase
local AppDatabase = class()

local user_version = 2

---@param migrations table?
function AppDatabase:new(migrations)
	self.migrations = migrations or {}

	local db = LsqliteDatabase()
	self.db = db

	local _models = autoload("models")
	self.orm = TableOrm(db)
	self.models = Models(_models, self.orm)
end

function AppDatabase:load()
	self.db:open("db.sqlite")
	-- local sql = assert(love.filesystem.read("sphere/persistence/CacheModel/database.sql"))
	-- self.db:exec(sql)
	self.db:exec("PRAGMA foreign_keys = ON;")
	-- self:migrate()
end

function AppDatabase:unload()
	self.db:close()
end

function AppDatabase:migrate()
	local count = self.orm:migrate(user_version, self.migrations)
	if count > 0 then
		print("migrations applied: " .. count)
	end
end

function AppDatabase:createTables()
	for name, typ in ls.iter("models") do
		if typ == "file" then
			local model = self.models._models[name:match("^(.+)%..-$")]
			self.db:exec(model.create_query)
		end
	end
end

return AppDatabase
