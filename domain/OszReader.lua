local class = require("class")

---@class domain.OszReader
---@operator call: domain.OszReader
local OszReader = class()

---@param archiveFactory domain.IArchiveFactory
function OszReader:new(archiveFactory)
	self.archiveFactory = archiveFactory
end

local function parse_osu(s)
	local osu = {}
	local HitObjects = 0

	local block
	for line in (s:gsub("\r\n", "\n") .. "\n"):gmatch("([^\n]*)\n") do
		if line:find("^%[") then
			block = line:match("^%[(.+)%]")
		else
			if block == "Metadata" and line:find("^%a+:.*$") then
				local key, value = line:match("^(%a+):%s?(.*)")
				osu[key] = value
			elseif block == "HitObjects" and line ~= "" then
				HitObjects = HitObjects + 1
			end
		end
	end

	osu.HitObjects = HitObjects
	return osu
end

---@param path string
---@return table?
---@return string?
function OszReader:read(path)
	local zip, err = self.archiveFactory:open(path, "r")
	if not zip then
		return nil, err
	end

	local osu = {}

	for info in zip:files() do
		if info.filename:find("%.osu$") then
			zip:open_file()
			osu = parse_osu(zip:read(info.uncompressed_size))
			zip:close_file()
			break
		end
	end

	zip:close()

	return osu
end

return OszReader
