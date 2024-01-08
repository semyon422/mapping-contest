local http = require("lapis.nginx.http")
local cjson = require("cjson")
local class = require("class")

local Recaptcha = class()

Recaptcha.url = "https://www.google.com/recaptcha/api/siteverify"

function Recaptcha:new(secret_key)
	self.secret_key = secret_key
end

function Recaptcha:verify(ip, token, action, score)
	local body, status_code, headers = http.simple(self.url, {
		secret = self.secret_key,
		response = token,
		remoteip = ip
	})
	if status_code ~= 200 then
		return false, "recaptcha: " .. status_code
	end
	local captcha = cjson.decode(body)

	score = score or 0.5
	if not captcha.success or captcha.score < score or captcha.action ~= action then
		return false, body
	end

	return true
end

return Recaptcha
