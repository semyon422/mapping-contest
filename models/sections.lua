local sections = {}

sections.table_name = "sections"

sections.create_query = [[
CREATE TABLE IF NOT EXISTS "sections" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"contest_id" INTEGER NOT NULL,
	"name" TEXT NOT NULL UNIQUE,
	"description" TEXT NOT NULL,
	"time_base" INTEGER NOT NULL,
	"time_per_knote" INTEGER NOT NULL,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE
);
]]

sections.types = {}

sections.relations = {
	contest = {belongs_to = "contests", key = "contest_id"},
}

return sections
