local contests = {}

contests.table_name = "contests"

contests.types = {
	is_visible = "boolean",
	is_submission_open = "boolean",
	is_voting_open = "boolean",
	is_anon = "boolean",
}

contests.relations = {
	host = {belongs_to = "users", key = "host_id"},
	tracks = {has_many = "tracks", key = "contest_id"},
	contest_users = {has_many = "contest_users", key = "contest_id"},
	charts = {has_many = "charts", key = "contest_id"},
	sections = {has_many = "sections", key = "contest_id"},
	user_contest_chart_votes = {has_many = "user_contest_chart_votes", key = "contest_id"},
}

return contests
