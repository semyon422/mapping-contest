local get_file = {}

get_file.policy_set = {file = {"files", {id = "file_id"}}}

function get_file.handler(params, models)
	params.content = params.file:read_file()
	return "ok", params
end

return get_file
