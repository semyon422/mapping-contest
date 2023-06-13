local date = require("date")

local Datetime = {}

function Datetime.to_iso(t)
	return date(t):fmt("${iso}")
end

function Datetime.to_text(t)
	return date(t):fmt("%F %T")
end

function Datetime.to_unix(t)
	return date.diff(t, "1970-01-01T00:00"):spanseconds()
end

return Datetime
