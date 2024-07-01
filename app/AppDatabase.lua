local class = require("class")
local LsqliteDatabase = require("rdb.LsqliteDatabase")
local TableOrm = require("rdb.TableOrm")
local Models = require("rdb.Models")
local autoload = require("autoload")

---@class app.AppDatabase
---@operator call: app.AppDatabase
local AppDatabase = class()

local user_version = 0

---@param migrations table?
function AppDatabase:new(migrations)
	self.migrations = migrations or {}

	local db = LsqliteDatabase()
	self.db = db

	self.orm = TableOrm(db)
	self.models = Models(autoload("app.models"), self.orm)
end

function AppDatabase:load()
	self.db:open("db.sqlite")
	local f = assert(io.open("app/database.sql", "r"))
	local sql = f:read("*a")
	f:close()
	self.db:exec(sql)
	self.db:exec("PRAGMA foreign_keys = ON;")
	self:migrate()
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

return AppDatabase
