local filehash = require("util.filehash")

local files = {}

files.table_name = "files"

files.types = {
	uploaded = "boolean",
	hash = filehash,
}

files.relations = {}

return files
