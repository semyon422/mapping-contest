local ok = require("usecases.ok")

local test = {}

function test.all(t)
	local p = {}
	local res = ok:handle(p)
	t:eq(res, "ok")
end

return test
