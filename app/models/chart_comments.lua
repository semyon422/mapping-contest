local chart_comments = {}

chart_comments.table_name = "chart_comments"

chart_comments.types = {}

chart_comments.relations = {
	chart = {belongs_to = "charts", key = "chart_id"},
	user = {belongs_to = "users", key = "user_id"},
}

return chart_comments
