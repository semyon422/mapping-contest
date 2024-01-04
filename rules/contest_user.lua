local rule = {}

function rule:condition(params)
	local user_id = params.session.user_id
	for _, contest_user in ipairs(params.contest.contest_users) do
		if contest_user.user_id == user_id then
			return true
		end
	end
end

return rule
