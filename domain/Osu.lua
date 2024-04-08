local class = require("class")

---@class domain.Osu
---@operator call: domain.Osu
local Osu = class()

function Osu:decode(s)
	self.sections = {}
	local sections = self.sections

	self.kv_space = {}

	local section_name, section
	for line in (s:gsub("\r\n", "\n") .. "\n"):gmatch("([^\n]*)\n") do
		if line:find("^%[") then
			section_name = line:match("^%[(.+)%]")
			section = {}
			sections[section_name] = section
			sections[#sections + 1] = section_name
		elseif section then
			local key, space, value = line:match("^(%a+):(%s?)(.*)")
			if key then
				section[key] = value
				section[#section + 1] = key
				self.kv_space[key] = space
			else
				section[#section + 1] = line
			end
			if section_name == "Events" and line:find("^0,0,") then
				self.background = line:match('"(.+)"')
			end
		end
	end
end

function Osu:encode()
	local out_lines = {}

	table.insert(out_lines, "osu file format v14")
	table.insert(out_lines, "")

	for _, section_name in ipairs(self.sections) do
		local section = self.sections[section_name]
		table.insert(out_lines, ("[%s]"):format(section_name))
		for _, key in ipairs(section) do
			local value = section[key]
			if value then
				table.insert(out_lines, ("%s:%s%s"):format(key, self.kv_space[key], value))
			else
				if section_name == "Events" and key:find("^0,0,") then
					key = ("0,0,%q,0,0"):format(self.background)
				end
				table.insert(out_lines, key)
			end
		end
	end

	return table.concat(out_lines, "\r\n")
end

return Osu
