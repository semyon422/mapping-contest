return {
	{"/ping", {
		GET = {"ping", {
			ok = {200, "json"},
		}},
	}},
	{"/", {
		GET = {"ok", {
			ok = {200, "home"},
		}},
	}},
	{"/login", {
		GET = {"get_login", {
			ok = {200, "login"},
		}},
	}},
	{"/login_osu", {
		GET = {"login_osu", {
			ok = {200, "login_osu"},
		}},
	}},
	{"/register", {
		GET = {"get_register", {
			ok = {200, "register"},
		}},
	}},
	{"/logout", {
		GET = {"logout", {
			ok = {200, "logout"},
		}},
	}},
	{"/oauth", {
		GET = {"oauth", {
			ok = {200, "oauth"},
		}},
	}},
	{"/users", {
		GET = {"get_users", {
			ok = {200, "users"},
		}},
	}},
	{"/users/:user_id", {
		GET = {"get_user", {
			ok = {200, "user"},
		}},
		PATCH = {"update_user", {
			ok = {200, "user"},
		}},
	}},
	{"/files/:file_id", {
		GET = {"get_file", {
			ok = {200, "download_file"},
		}},
	}},
	{"/contests", {
		GET = {"get_contests", {
			ok = {200, "contests"},
		}},
		POST = {"create_contest", {
			created = {302, "redirect_contest"},
		}},
	}},
	{"/contests/:contest_id", {
		GET = {"get_contest", {
			ok = {200, "contest"},
		}},
		DELETE = {"delete_contest", {
			deleted = {302, "redirect_contests"},
		}},
		PATCH = {"update_contest", {
			ok = {200, "contest"},
		}},
	}},
	{"/contests/:contest_id/user_chart_votes", {
		GET = {"get_votes", {
			ok = {200, "contest.user_chart_votes"},
		}},
		PATCH = {"update_vote", {
			ok = {200, "contest.user_chart_votes"},
		}},
	}},
}
