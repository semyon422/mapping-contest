local rule = {}

function rule:condition(params)
	return params.session_user ~= nil
end

return rule
