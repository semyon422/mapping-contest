local charts = {}

charts.table_name = "charts"

charts.create_query = [[
CREATE TABLE IF NOT EXISTS "charts" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"charter_id" INTEGER NOT NULL,
	"file_id" INTEGER NOT NULL,
	"contest_id" INTEGER NOT NULL,
	"track_id" INTEGER NOT NULL,
	"name" TEXT NOT NULL,
	"notes" INTEGER NOT NULL,
	"submitted_at" INTEGER NOT NULL,
	FOREIGN KEY (charter_id) references users(id) ON DELETE CASCADE,
	FOREIGN KEY (file_id) references files(id) ON DELETE CASCADE,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE,
	FOREIGN KEY (track_id) references tracks(id) ON DELETE CASCADE,
	UNIQUE(charter_id, file_id, contest_id, track_id)
);
]]

charts.types = {}

charts.relations = {
	charter = {belongs_to = "users", key = "charter_id"},
	file = {belongs_to = "files", key = "file_id"},
	contest = {belongs_to = "contests", key = "contest_id"},
	track = {belongs_to = "tracks", key = "track_id"},
}

return charts
