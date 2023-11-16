local Sections = {}

function Sections:get_max_heart_votes(charts_count)
	return math.ceil(charts_count / 6)
end

return Sections
