local function download_headers(result)
	return {
		["Pragma"] = "public",
		["Cache-Control"] = "must-revalidate, post-check=0, pre-check=0",
		["Content-Disposition"] = 'attachment; filename="' .. result.filename .. '"',
		["Content-Transfer-Encoding"] = "binary",
		["Content-Type"] = "application/octet-stream",
	}
end

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
			ok = {200, "LoginOptions"},
		}},
	}},
	{"/login", {
		GET = {"auth.get_login", {
			ok = {200, "Login"},
			validation = {200, "Login"},
		}},
		POST = {"auth.login", {
			ok = {302, nil, {["Location"] = "/"}},
			validation = {200, "Login"},
		}, "www_form"},
	}},
	{"/login_as", {
		POST = {"auth.login_as", {
			ok = {200},
		}, "www_form", "tonumber_id"},
	}},
	{"/register", {
		GET = {"auth.get_register", {
			ok = {200, "Register"},
		}},
		POST = {"auth.register", {
			ok = {302, nil, {["Location"] = "/"}},
			validation = {200, "Register"},
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
			error = {400, "Errors"},
		}},
	}},
	-- users
	{"/users", {
		GET = {"users.get_users", {
			ok = {200, "Users"},
		}},
	}},
	{"/users/:user_id", {
		GET = {"users.get_user", {
			ok = {200, "User"},
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
			ok = {200, "Contests"},
		}},
		POST = {"contests.create_contest", {
			created = {200, nil, function(result)
				return {["HX-Location"] = "/contests/" .. result.contest.id}
			end},
		}, "www_form"},
	}},
	{"/contests/:contest_id", {
		GET = {"contests.get_contest", {
			ok = {200, "Contest"},
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
		DELETE = {"contests.delete_track", {
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
	{"/charts/:chart_id/download", {
		GET = {"contests.download_chart", {
			ok = {200, "File", download_headers},
		}},
	}},
	{"/tracks/:track_id/download", {
		GET = {"contests.download_track", {
			ok = {200, "File", download_headers},
		}},
	}},
	{"/contests/:contest_id/download_pack", {
		GET = {"contests.download_pack", {
			ok = {200, "File", download_headers},
		}},
	}},
}
