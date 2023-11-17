local users = {}

users.table_name = "users"

users.create_query = [[
CREATE TABLE IF NOT EXISTS "users" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"osu_id" INTEGER NOT NULL,
	"name" TEXT NOT NULL UNIQUE,
	"discord" TEXT NOT NULL,
	"password" TEXT NOT NULL,
	"latest_activity" INTEGER NOT NULL,
	"created_at" INTEGER NOT NULL
);
]]

users.types = {}

users.relations = {
	user_roles = {has_many = "user_roles", key = "user_id"},
	contest_users = {has_many = "contest_users", key = "user_id"},
}

return users
