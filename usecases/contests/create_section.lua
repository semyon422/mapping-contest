local create_section = {}

create_section.policy_set = {{"contest_host"}}

create_section.models = {contest = {"contests", {id = "contest_id"}}}

function create_section.handler(params, models)
	models.sections:create({
		contest_id = params.contest.id,
		name = params.name,
		time_base = tonumber(params.time_base) or 0,
		time_per_knote = tonumber(params.time_per_knote) or 0,
	})

	return "ok", params
end

return create_section
