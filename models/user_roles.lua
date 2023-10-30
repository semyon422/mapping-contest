local user_roles = {}

user_roles.table_name = "user_roles"

user_roles.create_query = [[
CREATE TABLE IF NOT EXISTS "user_roles" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"user_id" INTEGER NOT NULL,
	"role" INTEGER NOT NULL,
	FOREIGN KEY (user_id) references users(id) ON DELETE CASCADE,
	UNIQUE(user_id, role)
);
]]

user_roles.types = {
	role = require("enums.roles"),
}

user_roles.relations = {
	user = {belongs_to = "users", key = "user_id"},
}

return user_roles
