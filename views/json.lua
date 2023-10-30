local json = require("cjson")

return function(result)
	return json.encode(result), {
		["Content-Type"] = "application/json"
	}
end
