local contests = {}

contests.table_name = "contests"

contests.create_query = [[
CREATE TABLE IF NOT EXISTS "contests" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"host_id" INTEGER NOT NULL,
	"name" TEXT NOT NULL UNIQUE,
	"description" TEXT NOT NULL,
	"created_at" INTEGER NOT NULL,
	"started_at" INTEGER NOT NULL,
	"is_visible" INTEGER NOT NULL,
	"is_submission_open" INTEGER NOT NULL,
	"is_voting_open" INTEGER NOT NULL,
	FOREIGN KEY (host_id) references users(id) ON DELETE CASCADE
);
]]

contests.types = {
	is_visible = "boolean",
	is_submission_open = "boolean",
	is_voting_open = "boolean",
}

contests.relations = {
	host = {belongs_to = "users", key = "host_id"},
}

return contests
