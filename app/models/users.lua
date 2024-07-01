local users = {}

users.table_name = "users"

users.types = {}

users.relations = {
	user_roles = {has_many = "user_roles", key = "user_id"},
	contest_users = {has_many = "contest_users", key = "user_id"},
}

return users
