local schema = require("lapis.db.schema")
local types = schema.types
local Appstruct = require("appstruct")

local struct = Appstruct()

struct.enums = {
	"roles",
	"votes",
	"sections",
}

struct.enums_above = {
	charts = {"sections"},
}

struct.primary = {
	{users = {"contests", "charts"}},
	{files = {"charts", "tracks"}},
	{contests = {"charts"}},
	{tracks = {"charts"}},
	{charts = {}},
}

struct.custom_keys = {
	contests = {users = "host_id"},
	charts = {users = "charter_id"},
}

struct.secondary = {
	{"users", "roles"},
	{"contests", "tracks"},
	{"users", "contests", "charts", "votes"},
}

-- https://github.com/leafo/lapis/blob/master/lapis/db/sqlite/schema.moon
local decls = {}
struct.decls = decls

decls.charts = {
	{"name", types.text},
	{"submitted_at", types.integer},
}

decls.contests = {
	{"name", types.text({unique = true})},
	{"description", types.text},
	{"created_at", types.integer},
	{"started_at", types.integer},
	{"is_visible", types.integer},
	{"is_submission_open", types.integer},
	{"is_voting_open", types.integer},
}

decls.files = {
	{"hash", types.blob({unique = true})},
	{"name", types.text},
	{"uploaded", types.integer},
	{"size", types.integer},
	{"created_at", types.integer},
}

decls.sections = {
	{"name", types.text({unique = true})},
	{"description", types.text},
	{"created_at", types.integer},
}

decls.tracks = {
	{"title", types.text},
	{"artist", types.text},
	{"created_at", types.integer},
}

decls.users = {
	{"name", types.text({unique = true})},
	{"osu_url", types.text},
	{"discord", types.text},
	{"password", types.text},
	{"latest_activity", types.integer},
	{"created_at", types.integer},
}

-- local struct_file = assert(io.open("struct.md", "w"))
-- struct_file:write(struct:get_string())
-- struct_file:close()

return struct
