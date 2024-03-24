local ok = require("usecases.ok")

local test = {}

function test.all(t)
	local p = {}
	local res, params = ok:handle(p)
	t:eq(res, "ok")
	t:eq(params, p)
end

return test
