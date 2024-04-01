local tracks = {}

tracks.table_name = "tracks"

tracks.create_query = [[
CREATE TABLE IF NOT EXISTS "tracks" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"file_id" INTEGER NOT NULL,
	"contest_id" INTEGER NOT NULL,
	"title" TEXT NOT NULL,
	"artist" TEXT NOT NULL,
	"created_at" INTEGER NOT NULL,
	FOREIGN KEY (file_id) references files(id) ON DELETE CASCADE,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE,
	UNIQUE(file_id)
);
]]

tracks.types = {}

tracks.relations = {
	file = {belongs_to = "files", key = "file_id"},
	contest = {belongs_to = "contests", key = "contest_id"},
}

return tracks
