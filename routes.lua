return {
	-- auth
	{"/", {
		GET = {"ok", {
			ok = {200, "home"},
		}},
	}},
	{"/login", {
		GET = {"auth.get_login", {
			ok = {200, "login"},
			validation = {200, "login"},
		}},
		POST = {"auth.login", {
			ok = {302, nil, {["Location"] = "/"}},
			validation = {200, "login"},
		}},
	}},
	{"/login_osu", {
		GET = {"auth.login_osu", {
			ok = {200, "login_osu"},
		}},
	}},
	{"/register", {
		GET = {"auth.get_register", {
			ok = {200, "register"},
		}},
	}},
	{"/logout", {
		POST = {"auth.logout", {
			ok = {200},
		}},
	}},
	{"/oauth", {
		GET = {"auth.oauth", {
			ok = {200, "oauth"},
		}},
	}},
	-- users
	{"/users", {
		GET = {"users.get_users", {
			ok = {200, "users"},
		}},
	}},
	{"/users/:user_id", {
		GET = {"users.get_user", {
			ok = {200, "user"},
		}},
		PATCH = {"users.update_user", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/users/" .. params.user.id}
			end},
		}},
	}},
	{"/users/:user_id/roles/:role", {
		PUT = {"auth.give_role", {
			ok = {200, "user"},
		}},
		DELETE = {"auth.remove_role", {
			ok = {200, "user"},
		}},
	}},
	-- contests
	{"/contests", {
		GET = {"contests.get_contests", {
			ok = {200, "contests"},
		}},
		POST = {"create_contest", {
			created = {302, nil, function(result)
				return {["Location"] = "/contests/" .. result.contest.id}
			end},
		}},
	}},
	{"/contests/:contest_id", {
		GET = {"contests.get_contest", {
			ok = {200, "contest"},
		}},
		DELETE = {"contests.delete_contest", {
			deleted = {302, "redirect_contests", {["HX-Location"] = "/contests"}},
		}},
		PATCH = {"contests.update_contest", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest.id}
			end},
		}},
	}},
	{"/contests/:contest_id/user_chart_votes", {
		GET = {"contests.get_votes", {
			ok = {200, "contest.user_chart_votes"},
		}},
		PATCH = {"contests.update_vote", {
			ok = {200, "contest.user_chart_votes"},
		}},
	}},
	-- other
	{"/files/:file_id", {
		GET = {"get_file", {
			ok = {200, "file", function(result)
				return {
					["Pragma"] = "public",
					["Cache-Control"] = "must-revalidate, post-check=0, pre-check=0",
					["Content-Disposition"] = 'attachment; filename="' .. result.file.name .. '"',
					["Content-Transfer-Encoding"] = "binary",
					["Content-Type"] = "application/octet-stream",
				}
			end},
		}},
	}},
}
