local zip = require("zip")
local IOszReader = require("domain.external.IOszReader")

---@class app.OszReader: domain.IOszReader
---@operator call: app.OszReader
local OszReader = IOszReader + {}

local function parse_osu(file)
	local osu = {}
	local HitObjects = 0

	local block
	for line in file:lines() do
		if line:find("^%[") then
			block = line:match("^%[(.+)%]")
		else
			if line:find("^%a+:.*$") then
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

---@param osz_file table
---@return table?
---@return string?
function OszReader:read(osz_file)
	local path = osz_file.path  -- not a good solution
	local zf, err = zip.open(path)
	if not zf then
		return nil, err
	end

	local osu = {}

	for info in zf:files() do
		if info.filename:find("%.osu$") then
			local file = zf:open(info.filename)
			osu = parse_osu(file)
			file:close()
			break
		end
	end

	zf:close()

	return osu
end

return OszReader
