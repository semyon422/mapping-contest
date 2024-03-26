local Errors = {
	not_found = 0,
	invalid = 1,
	forbidden = 2,
}

setmetatable(Errors, {__index = function(t, k)
	error(("Error.%s does not exist"):format(k))
end})

return Errors
