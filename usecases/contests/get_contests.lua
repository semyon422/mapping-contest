local get_contests = {}

function get_contests:handle(params)
	params.contests = self.models.contests:select()
	return "ok", params
end

return get_contests
