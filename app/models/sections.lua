local sections = {}

sections.table_name = "sections"

sections.types = {}

sections.relations = {
	contest = {belongs_to = "contests", key = "contest_id"},
}

return sections
