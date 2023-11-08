local filehash = require("util.filehash")

local files = {}

files.table_name = "files"

files.create_query = [[
CREATE TABLE IF NOT EXISTS "files" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"hash" BLOB NOT NULL UNIQUE,
	"name" TEXT NOT NULL,
	"uploaded" INTEGER NOT NULL,
	"size" INTEGER NOT NULL,
	"created_at" INTEGER NOT NULL
);
]]

files.types = {
	uploaded = "boolean",
	hash = filehash,
}

files.relations = {}

return files
