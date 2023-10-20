local date = require("date")
local config = require("lapis.config").get()

local Datetime = {}

function Datetime.to_iso(t)
	return date(t + config.timezone * 3600):fmt("${iso}")
end

function Datetime.to_text(t)
	return date(t + config.timezone * 3600):fmt("%F %T")
end

function Datetime.to_unix(t)
	return date.diff(t, "1970-01-01T00:00"):spanseconds() - config.timezone * 3600
end

return Datetime
