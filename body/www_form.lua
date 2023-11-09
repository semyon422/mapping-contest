local http_util = require("http_util")

return function(content_type)
	if content_type ~= "application/x-www-form-urlencoded" then
		return {}
	end
	ngx.req.read_body()
	local body = ngx.req.get_body_data()
	return http_util.decode_query_string(body)
end
