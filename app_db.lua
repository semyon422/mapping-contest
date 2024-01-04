local Models = require("rdb.Models")
local TableOrm = require("rdb.TableOrm")
local LsqliteDatabase = require("rdb.LsqliteDatabase")
local autoload = require("autoload")

local model_list = {
	"charts",
	"contest_tracks",
	"contest_users",
	"contests",
	"sections",
	"files",
	"tracks",
	"user_contest_chart_votes",
	"user_roles",
	"users",
}
local _models = autoload("models")

local app_db = {}

function app_db.init()
	app_db.db = LsqliteDatabase()
	app_db.db:open("db.sqlite")
	app_db.db:query("PRAGMA foreign_keys = ON;")
	app_db.models = Models(TableOrm(app_db.db), _models)
end

function app_db.create_tables()
	for _, m in ipairs(model_list) do
		app_db.db:query(_models[m].create_query)
	end
end

return app_db
