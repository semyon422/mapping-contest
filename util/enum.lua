return function(t)
	local enum = {}
	function enum.encode(k)
		local v = t[k]
		if v then
			return v
		end
		error("can not encode '" .. tostring(k) .. "'")
	end
	function enum.decode(v)
		for k, _v in pairs(t) do
			if v == _v then
				return k
			end
		end
		error("can not decode '" .. tostring(v) .. "'")
	end
	return enum
end
