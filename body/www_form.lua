local FormParser = require("web.body.FormParser")

---@param reader web.IBodyReader
---@param content_type string
---@return table
local function form(reader, content_type)
	if content_type ~= "application/x-www-form-urlencoded" then
		return {}
	end
	local parser = FormParser(reader)
	return parser:read()
end

return form
