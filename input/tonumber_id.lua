return function(params)
	for k, v in pairs(params) do
		if k:find("_id$") then
			params[k] = tonumber(v)
		end
	end
end
