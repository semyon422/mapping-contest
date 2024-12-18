local path_util = require("path_util")

local function download_headers(result)
	return {
		["Pragma"] = "public",
		["Cache-Control"] = "must-revalidate, post-check=0, pre-check=0",
		["Content-Disposition"] = 'attachment; filename="' .. path_util.fix_illegal(result.filename) .. '"',
		["Content-Transfer-Encoding"] = "binary",
		["Content-Type"] = "application/octet-stream",
	}
end

local uctx = require("web.framework.UsecasePageContext")
local Static = require("web.framework.StaticContext")

return {
	{"/css/:filename", {
		GET = Static("static/css"),
	}},
	{"/test", {
		GET = uctx {"ok", {
			ok = {200, "json"},
		}},
	}},
	{"/", {
		GET = uctx {"ok", {
			ok = {302, nil, {["Location"] = "/contests"}},
		}},
	}},
	-- auth
	{"/login_options", {
		GET = uctx {"auth.get_login", {
			ok = {200, "LoginOptions"},
		}},
	}},
	{"/login", {
		GET = uctx {"auth.get_login", {
			ok = {200, "Login"},
			validation = {200, "Login"},
		}},
		POST = uctx {"auth.login", {
			ok = {302, nil, {["Location"] = "/"}},
			validation = {200, "Login"},
		}, "www_form"},
	}},
	{"/login_as", {
		POST = uctx {"auth.login_as", {
			ok = {200},
		}, "www_form", "tonumber_id"},
	}},
	{"/register", {
		GET = uctx {"auth.get_register", {
			ok = {200, "Register"},
		}},
		POST = uctx {"auth.register", {
			ok = {302, nil, {["Location"] = "/"}},
			validation = {200, "Register"},
		}, "www_form"},
	}},
	{"/logout", {
		POST = uctx {"auth.logout", {
			ok = {200},
		}},
	}},
	{"/oauth", {
		GET = uctx {"auth.oauth", {
			ok = {302, nil, {["Location"] = "/"}},
			error = {400, "Errors"},
		}},
	}},
	-- users
	{"/users", {
		GET = uctx {"users.get_users", {
			ok = {200, "Users"},
		}},
	}},
	{"/users/:user_id", {
		GET = uctx {"users.get_user", {
			ok = {200, "User"},
		}},
		PATCH = uctx {"users.update_user", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/users/" .. params.user.id}
			end},
		}, "www_form", "update_user"},
	}},
	{"/users/:user_id/roles/:role", {
		PUT = uctx {"auth.give_role", {
			ok = {200},
		}},
		DELETE = uctx {"auth.remove_role", {
			ok = {200},
		}},
	}},
	-- contests
	{"/contests", {
		GET = uctx {"contests.get_contests", {
			ok = {200, "Contests"},
		}},
		POST = uctx {"contests.create_contest", {
			created = {200, nil, function(result)
				return {["HX-Location"] = "/contests/" .. result.contest.id}
			end},
		}, "www_form"},
	}},
	{"/contests/:contest_id", {
		GET = uctx {"contests.get_contest", {
			ok = {200, "Contest"},
		}},
		DELETE = uctx {"contests.delete_contest", {
			deleted = {302, nil, {["HX-Location"] = "/contests"}},
		}},
		PATCH = uctx {"contests.update_contest", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "www_form", "update_contest"},
	}},
	{"/contests/:contest_id/votes", {
		PATCH = uctx {"contests.update_vote", {
			ok = {200},
		}, "www_form", "tonumber_id"},
	}},
	{"/contests/:contest_id/sections", {
		POST = uctx {"contests.create_section", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "www_form", "update_section"},
	}},
	{"/contests/:contest_id/tracks", {
		POST = uctx {"contests.submit_track", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "multipart_file"},
	}},
	{"/contests/:contest_id/tracks/:track_id", {
		DELETE = uctx {"contests.delete_track", {
			deleted = {204},
		}},
	}},
	{"/contests/:contest_id/charts", {
		POST = uctx {"contests.submit_chart", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "multipart_file"},
	}},
	{"/contests/:contest_id/users", {
		POST = uctx {"contests.join_contest", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}},
	}},
	{"/contests/:contest_id/charts/:chart_id", {
		DELETE = uctx {"contests.delete_chart", {
			deleted = {204},
		}},
	}},
	{"/sections/:section_id", {
		PATCH = uctx {"contests.update_section", {
			ok = {200, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "www_form", "update_section"},
		DELETE = uctx {"contests.delete_section", {
			deleted = {204, nil, function(params)
				return {["HX-Location"] = "/contests/" .. params.contest_id}
			end},
		}, "www_form"},
	}},
	{"/charts/:chart_id/download", {
		GET = uctx {"contests.download_chart", {
			ok = {200, "File", download_headers},
		}},
	}},
	{"/charts/:chart_id/comments", {
		POST = uctx {"contests.create_comment", {
			ok = {200},
		}, "www_form"},
	}},
	{"/tracks/:track_id/download", {
		GET = uctx {"contests.download_track", {
			ok = {200, "File", download_headers},
		}},
	}},
	{"/contests/:contest_id/download_pack", {
		GET = uctx {"contests.download_pack", {
			ok = {200, "File", download_headers},
		}},
	}},
	{"/chart_comments/:chart_comment_id", {
		DELETE = uctx {"contests.delete_comment", {
			ok = {200},
		}},
	}},
}
