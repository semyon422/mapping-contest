return {
	secret = "please-change-me",
	hmac_digest = "sha256",
	session_name = "mapping-contest",

	osu_oauth = {
		client_id = 0,
		redirect_uri = "",
		client_secret = "",
	},
	timezone = 3,  -- MSK

	is_register_enabled = true,
	is_login_enabled = true,
	is_register_captcha_enabled = false,
	is_login_captcha_enabled = false,
	recaptcha = {
		site_key = "",
		secret_key = "",
	},
}
