local Sections = {}

Sections.list = {  -- see enums.sections
	"fast",
	"slow",
	"full",
}

Sections.time = {
	fast = {0.5, 1},
	slow = {1, 1.5},
	full = {math.huge, 0},
}

function Sections:get_section(time, notes)
	for _, name in ipairs(self.list) do
		local c = Sections.time[name]
		if (c[1] + c[2] * notes / 1000) * 3600 >= time then
			return name
		end
	end
end

-- 1000 notes

assert(Sections:get_section(1.49 * 3600, 1000) == "fast")
assert(Sections:get_section(1.51 * 3600, 1000) == "slow")

assert(Sections:get_section(2.49 * 3600, 1000) == "slow")
assert(Sections:get_section(2.51 * 3600, 1000) == "full")

-- 2000 notes

assert(Sections:get_section(2.49 * 3600, 2000) == "fast")
assert(Sections:get_section(2.51 * 3600, 2000) == "slow")

assert(Sections:get_section(3.99 * 3600, 2000) == "slow")
assert(Sections:get_section(4.01 * 3600, 2000) == "full")

function Sections:get_max_heart_votes(charts_count)
	return math.ceil(charts_count / 6)
end

return Sections
