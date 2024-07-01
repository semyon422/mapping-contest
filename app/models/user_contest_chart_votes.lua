local user_contest_chart_votes = {}

user_contest_chart_votes.table_name = "user_contest_chart_votes"

user_contest_chart_votes.types = {
	vote = require("domain.Votes").enum,
}

user_contest_chart_votes.relations = {
	user = {belongs_to = "users", key = "user_id"},
	contest = {belongs_to = "contests", key = "contest_id"},
	chart = {belongs_to = "charts", key = "chart_id"},
}

return user_contest_chart_votes
