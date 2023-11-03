local delete_track = {}

delete_track.policy_set = {{"contest_host"}}

function delete_track.handler(params, models)
	return "ok", params
end

return delete_track
