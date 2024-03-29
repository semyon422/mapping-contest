return {
	{"/test", {
		GET = {"ok", {
			ok = {200, "json"},
		}},
	}},
	{"/", {
		GET = {"ok", {
			ok = {302, nil, {["Location"] = "/contests"}},
		}},
	}},
	-- auth
	{"/login_options", {
		GET = {"auth.get_login", {
			ok = {200, {layout = "login_options"}},
		}},
	}},
	{"/login", {
		GET = {"auth.get_login", {
			ok = {200, {layout = "login"}},
			validation = {200, {layout = "login"}},
		}},
		POST = {"auth.login", {
			ok = {302, nil, {["Location"] = "/"}},
			validation = {200, "login"},
		}, "www_form"},
	}},
	{"/login_as", {
		POST = {"auth.login_as", {
			ok = {200},
		}, "www_form", "tonumber_id"},
	}},
	{"/register", {
		GET = {"auth.get_register", {
			ok = {200, {layout = "register"}},
		}},
		POST = {"auth.register", {
			ok = {302, nil, {["Location"] = "/"}},
			validation = {200, "register"},
		}, "www_form"},
	}},
	{"/logout", {
		POST = {"auth.logout", {
			ok = {200},
		}},
	}},
	{"/oauth", {
		GET = {"auth.oauth", {
			ok = {302, nil, {["Location"] = "/"}},
			error = {400, {layout = "errors"}},
		}},
	}},
	-- users
	{"/users", {
		GET = {"users.get_users", {
			ok = {200, {layout = "users"}},
		}},
	}},
	{"/users/:user_id", {
		GET = {"users.get_user", {
			ok = {200, {layout = "user"}},
		}},
		PATCH = {"users.update_user", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/users/" .. params.user.id}
			end},
		}, "www_form", "update_user"},
	}},
	{"/users/:user_id/roles/:role", {
		PUT = {"auth.give_role", {
			ok = {200},
		}},
		DELETE = {"auth.remove_role", {
			ok = {200},
		}},
	}},
	-- contests
	{"/contests", {
		GET = {"contests.get_contests", {
			ok = {200, {layout = "contests"}},
		}},
		POST = {"contests.create_contest", {
			created = {200, nil, function(result)
				return {["HX-Location"] = "/contests/" .. result.contest.id}
			end},
		}, "www_form"},
	}},
	{"/contests/:contest_id", {
		GET = {"contests.get_contest", {
			ok = {200, {layout = "contest"}},
		}},
		DELETE = {"contests.delete_contest", {
			deleted = {302, nil, {["HX-Location"] = "/contests"}},
		}},
		PATCH = {"contests.update_contest", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "www_form", "update_contest"},
	}},
	{"/contests/:contest_id/votes", {
		PATCH = {"contests.update_vote", {
			ok = {200},
		}, "www_form", "tonumber_id"},
	}},
	{"/contests/:contest_id/sections", {
		POST = {"contests.create_section", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "www_form", "update_section"},
	}},
	{"/contests/:contest_id/tracks", {
		POST = {"contests.submit_track", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "multipart_file"},
	}},
	{"/contests/:contest_id/tracks/:track_id", {
		DELETE = {"contests.delete_contest_track", {
			deleted = {204},
		}},
	}},
	{"/contests/:contest_id/charts", {
		POST = {"contests.submit_chart", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "multipart_file"},
	}},
	{"/contests/:contest_id/users", {
		POST = {"contests.join_contest", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}},
	}},
	{"/contests/:contest_id/charts/:chart_id", {
		DELETE = {"contests.delete_chart", {
			deleted = {204},
		}},
	}},
	{"/sections/:section_id", {
		PATCH = {"contests.update_section", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "www_form", "update_section"},
		DELETE = {"contests.delete_section", {
			deleted = {204, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "www_form"},
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
