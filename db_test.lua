local bcrypt = require("bcrypt")

local Votes = require("enums.votes")
local Roles = require("enums.roles")
local Sections = require("enums.sections")
local Filehash = require("util.filehash")

local struct = require("struct")
struct:define_models()

local Users = require("models.users")
local Contests = require("models.contests")
local Tracks = require("models.tracks")
local Files = require("models.files")
local Charts = require("models.charts")

local User_roles = require("models.user_roles")
local Contest_tracks = require("models.contest_tracks")
local User_contest_chart_votes = require("models.user_contest_chart_votes")

local db_test = {}

function db_test.create()
	struct:drop_tables()
	struct:create_tables()

	local user = Users:create({
		osu_id = 1,
		name = "admin",
		discord = "jhlee#0133",
		password = bcrypt.digest("password", 10),
		latest_activity = os.time(),
		created_at = os.time(),
	})

	local user_role = User_roles:create({
		user_id = user.id,
		role = Roles:for_db("verified"),
	})

	User_roles:create({
		user_id = user.id,
		role = Roles:for_db("admin"),
	})


	User_roles:create({
		user_id = user.id,
		role = Roles:for_db("moderator"),
	})

	User_roles:create({
		user_id = user.id,
		role = Roles:for_db("host"),
	})

	local contest = Contests:create({
		host_id = user.id,
		name = "First contest",
		description = "Contest description",
		created_at = os.time(),
		started_at = os.time(),
		is_visible = false,
		is_voting_open = false,
		is_submission_open = false,
	})

	local file = Files:create({
		hash = Filehash:sum_for_db("1"),
		name = "audio.mp3",
		uploaded = true,
		size = 1e6,
		created_at = os.time(),
	})

	local track = Tracks:create({
		file_id = file.id,
		title = "Title",
		artist = "Artist",
		created_at = os.time(),
	})

	local contest_track = Contest_tracks:create({
		contest_id = contest.id,
		track_id = track.id,
	})

	local chart_file = Files:create({
		hash = Filehash:sum_for_db("2"),
		name = "map.osu",
		uploaded = true,
		size = 1e3,
		created_at = os.time(),
	})

	local chart = Charts:create({
		track_id = track.id,
		charter_id = user.id,
		contest_id = contest.id,
		file_id = chart_file.id,
		section = Sections:for_db("slow"),
		name = "Insane",
		submitted_at = os.time(),
	})

	local user_contest_chart_vote = User_contest_chart_votes:create({
		contest_id = contest.id,
		user_id = user.id,
		chart_id = chart.id,
		vote = Votes:for_db("heart"),
	})
end

return db_test
