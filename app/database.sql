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

CREATE TABLE IF NOT EXISTS "contest_users" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"contest_id" INTEGER NOT NULL,
	"user_id" INTEGER NOT NULL,
	"started_at" INTEGER NOT NULL,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE,
	FOREIGN KEY (user_id) references users(id) ON DELETE CASCADE,
	UNIQUE(contest_id, user_id)
);

CREATE TABLE IF NOT EXISTS "contests" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"host_id" INTEGER NOT NULL,
	"name" TEXT NOT NULL UNIQUE,
	"description" TEXT NOT NULL,
	"created_at" INTEGER NOT NULL,
	"is_visible" INTEGER NOT NULL,
	"is_submission_open" INTEGER NOT NULL,
	"is_voting_open" INTEGER NOT NULL,
	"is_anon" INTEGER NOT NULL,
	FOREIGN KEY (host_id) references users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "files" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"hash" BLOB NOT NULL UNIQUE,
	"name" TEXT NOT NULL,
	"uploaded" INTEGER NOT NULL,
	"size" INTEGER NOT NULL,
	"created_at" INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS "sections" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"contest_id" INTEGER NOT NULL,
	"name" TEXT NOT NULL,
	"time_base" INTEGER NOT NULL,
	"time_per_knote" INTEGER NOT NULL,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "tracks" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"file_id" INTEGER NOT NULL,
	"contest_id" INTEGER NOT NULL,
	"title" TEXT NOT NULL,
	"artist" TEXT NOT NULL,
	"meta" TEXT NOT NULL,
	"created_at" INTEGER NOT NULL,
	FOREIGN KEY (file_id) references files(id) ON DELETE CASCADE,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE,
	UNIQUE(file_id)
);

CREATE TABLE IF NOT EXISTS "user_contest_chart_votes" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"user_id" INTEGER NOT NULL,
	"contest_id" INTEGER NOT NULL,
	"chart_id" INTEGER NOT NULL,
	"vote" INTEGER NOT NULL,
	FOREIGN KEY (user_id) references users(id) ON DELETE CASCADE,
	FOREIGN KEY (contest_id) references contests(id) ON DELETE CASCADE,
	FOREIGN KEY (chart_id) references charts(id) ON DELETE CASCADE,
	UNIQUE(user_id, contest_id, chart_id, vote)
);

CREATE TABLE IF NOT EXISTS "user_roles" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"user_id" INTEGER NOT NULL,
	"role" INTEGER NOT NULL,
	FOREIGN KEY (user_id) references users(id) ON DELETE CASCADE,
	UNIQUE(user_id, role)
);

CREATE TABLE IF NOT EXISTS "users" (
	"id" INTEGER NOT NULL PRIMARY KEY,
	"osu_id" INTEGER NOT NULL,
	"name" TEXT NOT NULL UNIQUE,
	"discord" TEXT NOT NULL,
	"password" TEXT NOT NULL,
	"latest_activity" INTEGER NOT NULL,
	"created_at" INTEGER NOT NULL
);
