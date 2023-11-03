local get_contests = {}

function get_contests.handler(params, models)
	params.contests = models.contests:select()
	return "ok", params
end

return get_contests
