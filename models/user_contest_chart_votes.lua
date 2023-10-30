local user_contest_chart_votes = {}

user_contest_chart_votes.table_name = "user_contest_chart_votes"

user_contest_chart_votes.create_query = [[
CREATE TABLE IF NOT EXISTS "user_contest_chart_votes" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"user_id" INTEGER NOT NULL,
	"contest_id" INTEGER NOT NULL,
	"chart_id" INTEGER NOT NULL,
	"vote" INTEGER NOT NULL,
	FOREIGN KEY (user_id) references users(id) ON DELETE CASCADE,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE,
	FOREIGN KEY (chart_id) references charts(id) ON DELETE CASCADE,
	UNIQUE(user_id, contest_id, chart_id, vote)
);
]]

user_contest_chart_votes.types = {
	vote = require("enums.votes"),
}

user_contest_chart_votes.relations = {
	user = {belongs_to = "users", key = "user_id"},
	contest = {belongs_to = "contests", key = "contest_id"},
	chart = {belongs_to = "charts", key = "chart_id"},
}

return user_contest_chart_votes
