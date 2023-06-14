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

config("development", {
	recaptcha = {
		is_enabled = false,
		site_key = "",
		secret_key = "",
	},
})

config("production", {
	recaptcha = {
		is_enabled = true,
		site_key = "",
		secret_key = "",
	},
})
