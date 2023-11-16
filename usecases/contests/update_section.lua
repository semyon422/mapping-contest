local update_section = {}

update_section.policy_set = {{"contest_host"}}

update_section.models = {
	contest = {"contests", {id = "contest_id"}},
	section = {"sections", {id = "section_id"}},
}

function update_section.handler(params, models)
	params.section:update({
		name = params.name,
		time_base = tonumber(params.time_base) or 0,
		time_per_knote = tonumber(params.time_per_knote) or 0,
	})

	return "ok", params
end

return update_section
