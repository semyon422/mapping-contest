local charts = {}

charts.table_name = "charts"

charts.types = {}

charts.relations = {
	charter = {belongs_to = "users", key = "charter_id"},
	file = {belongs_to = "files", key = "file_id"},
	contest = {belongs_to = "contests", key = "contest_id"},
	track = {belongs_to = "tracks", key = "track_id"},
	chart_comments = {has_many = "chart_comments", key = "chart_id"},
}

return charts
