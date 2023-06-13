local enum = require("lapis.db.model").enum

local Sections = enum({
	fast = 0,
	slow = 1,
	full = 2,
})

Sections.list = {
	"fast",
	"slow",
	"full",
}

local config = {
	fast = {0.5, 1},
	slow = {1, 1.5},
	full = {math.huge, 0},
}

function Sections:get_section(time, notes)
	for _, name in ipairs(self.list) do
		local c = config[name]
		if (c[1] + c[2] * notes) * 3600 >= time then
			return name
		end
	end
end

function Sections:get_max_heart_votes(charts_count)
	return math.ceil(charts_count / 6)
end

return Sections
