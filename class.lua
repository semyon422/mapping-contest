local extend = {}

---@param f function|string? Parent constructor
---@return table T Class table
---@return fun(...: any): table new Class constructor
---@return table mt Class metatable
return function(f)
	if type(f) == "string" then
		f = require(f)
	end
	if type(f) == "function" then
		f = f(extend)
	end
	local T = f or {}
	local mt = {__index = T}
	return T, function(...)
		local t = setmetatable({}, mt)
		if T.new and ... ~= extend then
			t:new(...)
		end
		return t
	end, mt
end
