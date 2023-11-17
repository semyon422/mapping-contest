local Models = require("rdb.Models")
local TableOrm = require("rdb.TableOrm")
local LsqliteDatabase = require("rdb.LsqliteDatabase")

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

local app_db = {}

function app_db.init()
	app_db.db = LsqliteDatabase()
	app_db.db:open("db.sqlite")
	app_db.db:query("PRAGMA foreign_keys = ON;")
	app_db.models = Models("models", TableOrm(app_db.db))
end

function app_db.create_tables()
	for _, model_name in ipairs(model_list) do
		local mod = require("models." .. model_name)
		app_db.db:query(mod.create_query)
	end
end

return app_db
