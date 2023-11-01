local Usecase = require("usecases.Usecase")

local get_file = Usecase()

get_file:bindModel("files", {id = "file_id"})

get_file:setHandler(function(params, models)
	-- return {
	-- 	file:read_file(),
	-- 	layout = false,
	-- 	content_type = "application/octet-stream",
	-- 	headers = {
	-- 		["Pragma"] = "public",
	-- 		["Cache-Control"] = "must-revalidate, post-check=0, pre-check=0",
	-- 		["Content-Disposition"] = 'attachment; filename="' .. file.name .. '"',
	-- 		["Content-Transfer-Encoding"] = "binary",
	-- 	},
	-- }
	return "ok", params
end)

return get_file
