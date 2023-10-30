local contest_tracks = {}

contest_tracks.table_name = "contest_tracks"

contest_tracks.create_query = [[
CREATE TABLE IF NOT EXISTS "contest_tracks" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"contest_id" INTEGER NOT NULL,
	"track_id" INTEGER NOT NULL,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE,
	FOREIGN KEY (track_id) references tracks(id) ON DELETE CASCADE,
	UNIQUE(contest_id, track_id)
);
]]

contest_tracks.types = {}

contest_tracks.relations = {
	contest = {belongs_to = "contests", key = "contest_id"},
	track = {belongs_to = "tracks", key = "track_id"},
}

return contest_tracks
