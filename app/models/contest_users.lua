local contest_users = {}

contest_users.table_name = "contest_users"

contest_users.types = {}

contest_users.relations = {
	contest = {belongs_to = "contests", key = "contest_id"},
	user = {belongs_to = "users", key = "user_id"},
}

return contest_users
