local config = require("lapis.config")

config({"development", "production"}, {
	server = "nginx",
	code_cache = "off",
	num_workers = "1",
	port = 8180,
	secret = "please-change-me",
	hmac_digest = "sha256",
	session_name = "mapping-contest",
	sqlite = {
		database = "db.sqlite",
	},
})

config("production", {
	code_cache = "on",
})

--------

config({"development", "production"}, {
	osu_oauth = {
		client_id = 0,
		redirect_uri = "",
		client_secret = "",
	},
})

config("development", {
	is_register_enabled = true,
	is_login_enabled = true,
	is_register_captcha_enabled = false,
	is_login_captcha_enabled = false,
	recaptcha = {
		site_key = "",
		secret_key = "",
	},
})

config("production", {
	is_register_enabled = true,
	is_login_enabled = true,
	is_register_captcha_enabled = true,
	is_login_captcha_enabled = true,
	recaptcha = {
		site_key = "",
		secret_key = "",
	},
})
