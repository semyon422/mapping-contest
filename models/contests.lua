local contests = {}

contests.table_name = "contests"

contests.create_query = [[
CREATE TABLE IF NOT EXISTS "contests" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"host_id" INTEGER NOT NULL,
	"name" TEXT NOT NULL UNIQUE,
	"description" TEXT NOT NULL,
	"created_at" INTEGER NOT NULL,
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
	contest_tracks = {has_many = "contest_tracks", key = "contest_id"},
	contest_users = {has_many = "contest_users", key = "contest_id"},
	charts = {has_many = "charts", key = "contest_id"},
	sections = {has_many = "sections", key = "contest_id"},
	user_contest_chart_votes = {has_many = "user_contest_chart_votes", key = "contest_id"},
}

return contests
