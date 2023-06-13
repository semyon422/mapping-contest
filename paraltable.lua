local mt = {}

local function paraltable(t, b)
	return setmetatable({
		__t = t,
		__b = b,
	}, mt)
end

function mt.__index(s, k)
	local t = s.__t[k]
	local b = s.__b[k]
	if t and (type(t) ~= "table" or not b) then
		return t
	elseif b and (type(b) ~= "table" or not t) then
		return b
	end
	return paraltable(t, b)
end

return paraltable
