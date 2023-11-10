require("pkg_config")
local app_db = require("app_db")

os.remove("db.sqlite")
app_db.init()
app_db.create_tables()

local models = app_db.models

local register = require("usecases.auth.register")

local session = {}

assert(register.handler({
	name = "admin",
	discord = "discord",
	password = "password",
	session = session,
}, models) == "ok")
