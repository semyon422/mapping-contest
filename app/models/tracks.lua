local stbl = require("stbl")

local tracks = {}

tracks.table_name = "tracks"

tracks.types = {
	meta = stbl,
}

tracks.relations = {
	file = {belongs_to = "files", key = "file_id"},
	contest = {belongs_to = "contests", key = "contest_id"},
}

return tracks
