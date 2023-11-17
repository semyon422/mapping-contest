local contest_users = {}

contest_users.table_name = "contest_users"

contest_users.create_query = [[
CREATE TABLE IF NOT EXISTS "contest_users" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"contest_id" INTEGER NOT NULL,
	"user_id" INTEGER NOT NULL,
	"started_at" INTEGER NOT NULL,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE,
	FOREIGN KEY (user_id) references users(id) ON DELETE CASCADE,
	UNIQUE(contest_id, user_id)
);
]]

contest_users.types = {}

contest_users.relations = {
	contest = {belongs_to = "contests", key = "contest_id"},
	user = {belongs_to = "users", key = "user_id"},
}

return contest_users
