local File = require("domain.File")

local get_file = {}

get_file.models = {file = {"files", {id = "file_id"}}}

function get_file.handle(params, models)
	local file = File(params.file.hash)
	params.content = file:read()
	return "ok", params
end

return get_file
