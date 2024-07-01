local user_roles = {}

user_roles.table_name = "user_roles"

user_roles.types = {
	role = require("domain.Roles").enum,
}

user_roles.relations = {
	user = {belongs_to = "users", key = "user_id"},
}

return user_roles
