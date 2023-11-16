local delete_section = {}

delete_section.policy_set = {{"contest_host"}}

delete_section.models = {
	contest = {"contests", {id = "contest_id"}},
	section = {"sections", {id = "section_id"}},
}

function delete_section.handler(params, models)
	params.section:delete()

	return "deleted", params
end

return delete_section
