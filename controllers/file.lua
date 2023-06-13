local file_c = {}

file_c.GET = function(self)
	local file = self.ctx.file

	return {
		file:read_file(),
		layout = false,
		content_type = "application/octet-stream",
		headers = {
			["Pragma"] = "public",
			["Cache-Control"] = "must-revalidate, post-check=0, pre-check=0",
			["Content-Disposition"] = 'attachment; filename="' .. file.name .. '"',
			["Content-Transfer-Encoding"] = "binary",
		},
	}
end

return file_c
